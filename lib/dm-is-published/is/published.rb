module DataMapper
  module Is
    
    # = dm-is-published
    # 
    # This plugin makes it very easy to add different states to your models, like 'draft' vs 'live'. 
    # By default it also adds validations of the field value.
    # 
    # Originally inspired by the Rails plugin +acts_as_publishable+ by <b>fr.ivolo.us</b>. 
    # 
    # 
    # == Installation
    # 
    #   #  Add GitHub to your RubyGems sources 
    #   $  gem sources -a http://gems.github.com
    # 
    #   $  (sudo)? gem install kematzy-dm-is-published
    # 
    # <b>NB! Depends upon the whole DataMapper suite being installed, and has ONLY been tested with DM 0.10.0 (next branch).</b>
    # 
    # 
    # == Getting Started
    # 
    # First of all, for a better understanding of this gem, make sure you study the '<tt>dm-is-published/spec/integration/published_spec.rb</tt>' file.
    # 
    # ----
    # 
    # Require +dm-is-published+ in your app.
    # 
    #   require 'dm-core'         # must be required first
    #   require 'dm-is-published'
    # 
    # Lets say we have an Article class, and each Article can have a current state, 
    # ie: whether it's Live, Draft or an Obituary awaiting the death of someone famous (real or rumored)
    # 
    # 
    #     class Article
    #       include DataMapper::Resource
    #       property :id,     Serial
    #       property :title,   String
    #       ...<snip>
    # 
    #       is :published
    # 
    #     end
    # 
    # Once you have your Article model we can create our Articles just as normal
    # 
    #     Article.create(:title => 'Example 1')
    # 
    # 
    # The instance of <tt>Article.get(1)</tt> now has the following things for free:
    # 
    # * a <tt>:publish_status</tt> attribute with the value <tt>'live'</tt>. Default choices are <tt>[ :live, :draft, :hidden ]</tt>.
    # 
    # * <tt>:is_live?, :is_draft? or :is_hidden?</tt> methods that returns true/false based upon the state.
    # 
    # * <tt>:save_as_live</tt>, <tt>:save_as_draft</tt> or <tt>:save_as_hidden</tt> converts the instance to the state and saves it.
    # 
    # * <tt>:publishable?</tt> method that returns true for models where <tt>is :published </tt> has been declared,
    #   but <b>false</b> for those where it has not been declared.
    # 
    # 
    # The Article class also gets a bit of new functionality:
    # 
    #     Article.all(:draft)  =>  finds all Articles with :publish_status = :draft
    # 
    # 
    #     Article.all(:draft, :author => @author_joe )  =>  finds all Articles with :publish_status = :draft and author == Joe
    # 
    # 
    # Todo:: add more documentation here...
    # 
    # 
    # == Usage Scenarios
    # 
    # In a Blog/Publishing scenario you could use it like this:
    # 
    #   class Article 
    #     ...<snip>...
    # 
    #     is :published :live, :draft, :hidden
    #   end
    # 
    # Whereas in another scenario - like in a MenuItem model for a Restaurant - you could use it like this:
    # 
    #   class MenuItem
    #     ...<snip>...
    #     
    #     is :published  :on, :off  # the item is either on the menu or not
    #   end
    # 
    # 
    # == RTFM 
    # 
    # As I said above, for a better understanding of this gem/plugin, make sure you study the '<tt>dm-is-published/spec/integration/published_spec.rb</tt>' file.
    # 
    # 
    # == Errors / Bugs
    # 
    # If something is not behaving intuitively, it is a bug, and should be reported.
    # Report it here: http://github.com/kematzy/dm-is-published/issues
    # 
    # == Credits
    # 
    # Copyright (c) 2008-05-07 [Kematzy at gmail]
    # 
    # Loosely based on the ActsAsPublishable plugin by [http://fr.ivolo.us/posts/acts-as-publishable]
    # 
    # == Licence
    # 
    # Released under the MIT license.
    
    module Published
      
      ##
      # method that adds a basic published status attribute to your model
      # 
      # == params 
      # 
      # * +states+ - an array of 'states' as symbols or strings. ie: :live, :draft, :hidden
      # 
      # ==== Examples
      # 
      #   
      #   is :published :on, :off
      #   
      #   is :published %w(a b c d)
      #   
      # 
      # @api public
      def is_published(*args)
        # set default args if none passed in
        args = [:live, :draft, :hidden] if args.blank?
        args = args.first if args.first.is_a?(Array)
        
        # the various publish states accepted.
        @publish_states = args.collect{ |state| state.to_s.downcase.to_sym }
        @publish_states_for_validation = args.collect{ |state| state.to_s.downcase }
        
        extend  DataMapper::Is::Published::ClassMethods
        include DataMapper::Is::Published::InstanceMethods
        
        # do we have a :publish_status declared
        if properties.any?{ |p| p.name == :publish_status }
          
          # set default value to first value in declaration or the given value
          d = properties[:publish_status].default.blank? ? @publish_states.first.to_s : properties[:publish_status].default
          
          # set the length to 10 if missing or if shorter than 5, otherwise use the given value
          l = 5  if properties[:publish_status].length.blank?
          l = (properties[:publish_status].length <= 10 ? 10 : properties[:publish_status].length)
          
          property :publish_status, String, :length => l, :default => d.to_s
        else
          # no such property, so adding it with default values
          property :publish_status, String, :length => 10, :default => @publish_states.first.to_s 
        end
        
        # create the state specific instance methods
        self.publish_states.each do |state|
          define_method("is_#{state}?") do 
            self.publish_status == state.to_s
          end
          define_method("save_as_#{state}") do 
            self.publish_status = state.to_s
            save
          end
        end
        
        # ensure we are always saving publish_status values as strings
        before :valid? do
          self.publish_status = self.publish_status.to_s if self.respond_to?(:publish_status)
        end
        
        validates_within    :publish_status, 
                            :set => @publish_states_for_validation,
                            :message => "The publish_status value can only be one of these values: [ #{@publish_states_for_validation.join(', ')} ]"
        
      end
      
      module ClassMethods
        attr_reader :publish_states, :publish_states_for_validation
        
        ##
        # Returns a JSON representation of the publish states, where each state 
        # is represented as a lowercase key and an uppercase value.
        #  
        # ==== Examples
        # 
        #   Model.publish_states_as_json  
        #     
        #     => { 'live': 'LIVE','draft': 'DRAFT','hidden': 'HIDDEN' }
        # 
        # @api public
        def publish_states_as_json
          %Q[{ #{self.publish_states_for_validation.collect{ |state| "'#{state.to_s.downcase}': '#{state.to_s.upcase}'" }.join(',')} }]
        end
        
        ##
        # Overriding the normal #all method to add some extra sugar.
        #  
        # ==== Examples
        # 
        #   Article.all  => returns all Articles as usual
        # 
        #   Article.all( :publish_status => :live )  => returns all Articles with :publish_status == :lve
        # 
        #   Article.all(:draft)  => returns all Articles with :publish_status == :draft
        # 
        #   Article.all(:draft, :author => @author_joe )  => finds all Articles with :publish_status = :draft and author == Joe
        # 
        # 
        # @api public/private
        def all(*args)
          # incoming can either be:  
          # -- nil (nothing passed in, so just use super )
          # -- (Hash)  => all(:key => "value") ( normal operations, so just pass on the Hash ) 
          # -- (Symbol)  => all(:draft) ( just get the symbol, )
          # -- (Symbol, Hash )  => :draft, { extra options }
          # -- (DataMapper somethings) => leave it alone
          if args.empty?
            return super 
          elsif args.first.is_a?(Symbol)
            # set the from args Array, remove first item if Symbol, and then check for 2nd item's presence
            state, options = args.shift.to_s, (args.blank? ? {} : args.first) 
            # puts " and state=[#{state}] and options=[#{options.class}] options.inspect=[#{options.inspect}] [#{__FILE__}:#{__LINE__}]"
            return super({ :publish_status => state }.merge(options) )
          elsif args.first.is_a?(Hash)
            # puts "dm-is-published args.first was a HASH ] [#{__FILE__}:#{__LINE__}]"
            return super(args.first)
          else
            # puts "dm-is-published (ELSE) [#{__FILE__}:#{__LINE__}]"
            return super
          end
        end
        
      end # ClassMethods
      
      module InstanceMethods 
        
        ##
        # Ensuring all models using this plugin responds to publishable? with true.
        #  
        # ==== Examples
        # 
        #   @published_model.publishable?  =>  true
        # 
        # @api public
        def publishable?
          true
        end
        
      end # InstanceMethods
      
      module ResourceInstanceMethods 
        
        ##
        # Ensuring all models NOT using this plugin responds to publishable? with false.
        #  
        # ==== Examples
        # 
        #   @unpublished_model.publishable?  =>  false
        # 
        # @api public
        def publishable?
          false
        end
        
      end #/module ResourceInstanceMethods
      
    end # Published
  end # Is
  
  Model.append_extensions(Is::Published)
  
end # DataMapper
