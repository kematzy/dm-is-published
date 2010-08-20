require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent + 'spec_helper'

if HAS_SQLITE3 || HAS_MYSQL || HAS_POSTGRES
  describe 'DataMapper::Is::Published' do
    
    class DefaultsArticle
      include DataMapper::Resource
      property :id,     Serial
      property :title,   String
      
      is :published
    end 
    
    class Article
      include DataMapper::Resource
      property :id,     Serial
      property :title,   String
      
      is :published, :live, :draft, :prepared
    end 
    
    class Image
      include DataMapper::Resource
      property :id,     Serial
      property :title,   String
      
      is :published, :yes, :no
    end 
    
    
    before(:each) do 
      DefaultsArticle.auto_migrate!
      Article.auto_migrate!
      Image.auto_migrate!
      
      %w(live draft hidden).each do |state|
        DefaultsArticle.create(:title => "#{state.capitalize} DefaultsArticle", :publish_status => state )
      end
      %w(live draft prepared).each do |state|
        Article.create(:title => "#{state.capitalize} Article", :publish_status => state )
      end
      %w(yes no).each do |state|
        Image.create(:title => "#{state.capitalize} Image", :publish_status => state )
      end
      
    end
    
    
    describe "Property :publish_status" do 
      
      class ArticleWithoutDefaultAndTooShortLength
        include DataMapper::Resource
        property :id,     Serial
        property :publish_status, String, :length => 2
        
        is :published
      end 
      
      class ArticleWithDefaultAndLongerLength
        include DataMapper::Resource
        property :id,     Serial
        property :publish_status, String, :length => 100, :default => 'hidden' 
        
        is :published
      end 
      
      describe ":length => X" do 
        
        it "should set the :publish_status length to the default value of 5 if declared shorter" do 
          ArticleWithoutDefaultAndTooShortLength.properties[:publish_status].length.should == 10
        end
        
        it "should NOT set the :publish_status length to the default value of 5 if declared is longer" do 
          ArticleWithDefaultAndLongerLength.properties[:publish_status].length.should == 100
        end
        
      end #/ length
      
      describe ":default => X" do 
        
        it "should set the :publish_status default value to the first item in the method declaration" do 
          ArticleWithoutDefaultAndTooShortLength.properties[:publish_status].default.should == 'live'
          Article.properties[:publish_status].default.should == 'live'
          Image.properties[:publish_status].default.should == 'yes'
        end
        
        it "should set the default value to the declared value" do 
          ArticleWithDefaultAndLongerLength.properties[:publish_status].default.should == 'hidden'
        end
        
      end #/ default
      
    end #/ Property :publish_status
    
    describe "Class Methods" do 
      
      describe "#publish_states" do 
        
        it "should return the states as an array of Symbols" do 
          DefaultsArticle.publish_states.should == [:live, :draft, :hidden]
          Article.publish_states.should == [:live, :draft, :prepared]
          Image.publish_states.should == [:yes, :no]
        end
        
        class ArticleWithDeclarationAsArray
          include DataMapper::Resource
          property :id,     Serial
          is :published, [:a, :b, :c]
        end 
        
        it "should handle the states declared within [ Array ] brackets" do
          ArticleWithDeclarationAsArray.publish_states.should == [:a, :b, :c]
        end
        
        class ArticleWithDeclarationAsArrayOfStrings
          include DataMapper::Resource
          property :id,     Serial
          is :published, %w(a b c)
        end 
        
        it "should handle the states declared as %w(a b c) " do
          ArticleWithDeclarationAsArrayOfStrings.publish_states.should == [:a, :b, :c]
        end
        
      end #/ #publish_states
      
      describe "#publish_states_for_validation" do 
        
        it "should return the states as an array of Strings" do 
          DefaultsArticle.publish_states_for_validation.should == ["live", "draft", "hidden"]
          Article.publish_states_for_validation.should == ["live", "draft", "prepared"]
          Image.publish_states_for_validation.should == ["yes", "no"]
        end
        
      end #/ #publish_states
      
      describe "#publish_states_as_json" do 
        
        it "should return the states as an array of Symbols" do 
          DefaultsArticle.publish_states_as_json.should == "{ 'live': 'LIVE','draft': 'DRAFT','hidden': 'HIDDEN' }"
          Article.publish_states_as_json.should == "{ 'live': 'LIVE','draft': 'DRAFT','prepared': 'PREPARED' }"
          Image.publish_states_as_json.should == "{ 'yes': 'YES','no': 'NO' }"
        end
        
        class ArticleWithDeclarationAsArray
          include DataMapper::Resource
          property :id,     Serial
          is :published, [:a, :b, :c]
        end 
        
        it "should handle the states declared within [ Array ] brackets" do
          ArticleWithDeclarationAsArray.publish_states_as_json.should == "{ 'a': 'A','b': 'B','c': 'C' }"
        end
        
        class ArticleWithDeclarationAsArrayOfStrings
          include DataMapper::Resource
          property :id,     Serial
          is :published, %w(a b c)
        end 
        
        it "should handle the states declared as %w(a b c) " do
          ArticleWithDeclarationAsArrayOfStrings.publish_states_as_json.should == "{ 'a': 'A','b': 'B','c': 'C' }"
        end
        
      end #/ #publish_states
      
      describe "#all" do 
        
        before(:each) do 
          5.times do |n|
            Article.create(:title => "Dummy Article #{n +1}")
          end
        end
        
        it "should work as expected with Model.all" do
          Article.all.size.should == 8
        end
        
        it "should work as expected with Model.all(:publish_status => state) (finding only those records with the state) " do 
          Article.all( :publish_status => :live ).size.should == 6
        end
        
        it "should work as expected with Model.all(:state) (finding only those records with the given state) " do 
          Article.all(:live).size.should == 6
        end
        
        it "should work as expected with Model.all(:state,{ conditions } ) (finding only the items with the given state and conditions) " do 
          Article.all(:live, :title => "Dummy Article 1" ).size.should == 1
        end
        
      end #/ #self.all
      
      describe "#first" do 
        
        it "should description" do 
          # Article.first.should == ''
          # Article.first(:title => "Live Article").should == ''
        end
        
      end #/ #first
      
    end #/ Class Methods
    
    describe "Instance Methods" do 
      
      describe "#publish_status" do 
        
        it "should return the state as a String" do 
          Article.get(1).publish_status.should be_a_kind_of(String)
        end
        
        it "should set the default status as the first item in the list when is :published is defined " do
          a = Article.create(:title => "Article with default publish_status" )
          a.publish_status.should == 'live'
        end
        
      end #/ #publish_status
      
      describe "#publishable?" do 
        
        it "should return true for a Model with is :published declared" do 
          Article.get(1).publishable?.should == true
        end
        
        it "should return false when Model does NOT have is :published declared" do 
          class UnPublishedModel
            include DataMapper::Resource
            property :id, Serial
          end
          
          UnPublishedModel.new.should respond_to(:publishable?)
          UnPublishedModel.new.publishable?.should == false
        end
        
      end #/ #publishable?
      
      describe "defined :is_STATE? methods" do 
        
        describe "#is_live?" do 
          
          it "should return true on live articles" do 
            Article.get(1).is_live?.should == true
          end
          
          it "should return false on all others" do 
            Article.get(2).is_live?.should == false
            Article.get(3).is_live?.should == false
          end
          
        end #/ #is_live?
        
        describe "#is_draft?" do 
          
          it "should return true on draft articles" do 
            Article.get(2).is_draft?.should == true
          end
          
          it "should return false on all others" do 
            Article.get(1).is_draft?.should == false
            Article.get(3).is_draft?.should == false
          end
          
        end #/ #is_draft?
        
        describe "#is_prepared?" do 
          
          it "should return true on prepared articles" do 
            Article.get(3).is_prepared?.should == true
          end
          
          it "should return false on all others" do 
            Article.get(1).is_prepared?.should == false
            Article.get(2).is_prepared?.should == false
          end
          
        end #/ #is_prepared?
        
      end #/ defined :is_STATE? methods
      
      describe "defined :save_as_STATE? methods" do 
        
        Article.publish_states.each do |state| 
          
          describe "#save_as_#{state}" do 
            
            it "should save item as :#{state}" do 
              a = Article.new(:title => "Saved As #{state.to_s.capitalize} article" )
              a.send("save_as_#{state}").should == true
              a.publish_status.should == state.to_s
            end
            
          end #/ #save_as_
          
        end
        
        Image.publish_states.each do |state| 
          
          describe "#save_as_#{state}" do 
            
            it "should save item as :#{state}" do 
              a = Image.new(:title => "Saved As #{state.to_s.capitalize}" )
              a.send("save_as_#{state}").should == true
              a.publish_status.should == state.to_s
            end
            
          end #/ #save_as_
          
        end
        
        it "should enable changing the publish status" do 
          a = Article.get(1)
          a.publish_status.should == 'live'
          a.save_as_draft
          a.reload
          a.publish_status.should == 'draft'
        end
        
      end #/ defined :is_STATE? methods
      
    end #/ Instance Methods
    
    describe "Validations" do 
      
      it "should accept the defined states" do 
        %w(live draft prepared).each do |state|
          a = Article.new(:title => "Accepted Validated Article", :publish_status => state )
          a.save.should == true
          a.errors.on(:publish_status).should == nil
        end
      end
      
      it "should reject all other states and return a Validation error with the possible states in the message text" do 
        a = Article.new(:title => "Rejected Article", :publish_status => :invalid )
        a.save.should == false
        a.errors.on(:publish_status).should == ["The publish_status value can only be one of these values: [ live, draft, prepared ]"]
      end
      
    end #/ Validations
    
  end
end
