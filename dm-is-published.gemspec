# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{dm-is-published}
  s.version = "0.0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["kematzy"]
  s.date = %q{2009-07-12}
  s.description = %q{= dm-is-published

This plugin makes it very easy to add different states to your models, like 'draft' vs 'live'. 
By default it also adds validations of the field value.

Originally inspired by the Rails plugin +acts_as_publishable+ by <b>fr.ivolo.us</b>. 


== Installation
  
  #  Add GitHub to your RubyGems sources 
  $  gem sources -a http://gems.github.com
  
  $  (sudo)? gem install kematzy-dm-is-published
  
<b>NB! Depends upon the whole DataMapper suite being installed, and has ONLY been tested with DM 0.10.0 (next branch).</b>


== Getting Started

First of all, for a better understanding of this gem, make sure you study 
the '<tt>dm-is-published/spec/integration/published_spec.rb</tt>' file.

----

Require +dm-is-published+ in your app.

  require 'dm-core'         # must be required first
  require 'dm-is-published'

Lets say we have an Article class, and each Article can have a current state, 
ie: whether it's Live, Draft or an Obituary awaiting the death of someone famous (real or rumored)


    class Article
      include DataMapper::Resource
      property :id,     Serial
      property :title,   String
      ...<snip>
      
      is :published
      
    end
    
Once you have your Article model we can create our Articles just as normal

    Article.create(:title => 'Example 1')
    

The instance of <tt>Article.get(1)</tt> now has the following things for free:

* a <tt>:publish_status</tt> attribute with the value <tt>'live'</tt>. Default choices are <tt>[ :live, :draft, :hidden ]</tt>.

* <tt>:is_live?, :is_draft? or :is_hidden?</tt> methods that returns true/false based upon the state.

* <tt>:save_as_live</tt>, <tt>:save_as_draft</tt> or <tt>:save_as_hidden</tt> converts the instance to the state and saves it.

* <tt>:publishable?</tt> method that returns true for models where <tt>is :published </tt> has been declared,
  but <b>false</b> for those where it has not been declared.


The Article class also gets a bit of new functionality:

    Article.all(:draft)  =>  finds all Articles with :publish_status = :draft
    
    
    Article.all(:draft, :author => @author_joe )  =>  finds all Articles with :publish_status = :draft and author == Joe
    
    
    
Todo Need to write more documentation here..

    
== Usage Scenarios

In a Blog/Publishing scenario you could use it like this:

  class Article 
    ...<snip>...
    
    is :published :live, :draft, :hidden
    
  end

Whereas in another scenario - like in a MenuItem model for a Restaurant - you could use it like this:

  class MenuItem
    ...<snip>...
    
    is :published  :on, :off  # the item is either on the menu or not
    
  end
  

== RTFM 

As I said above, for a better understanding of this gem/plugin, make sure you study the '<tt>dm-is-published/spec/integration/published_spec.rb</tt>' file.


== Errors / Bugs

If something is not behaving intuitively, it is a bug, and should be reported.
Report it here: http://datamapper.lighthouseapp.com/

=== Credits

Copyright (c) 2009-07-11 [kematzy gmail com]

Loosely based on the ActsAsPublishable plugin by [http://fr.ivolo.us/posts/acts-as-publishable]

== Licence

Released under the MIT license.
}
  s.email = %q{kematzy@gmail.com}
  s.extra_rdoc_files = [
    "History.txt",
     "LICENSE",
     "README.rdoc",
     "TODO"
  ]
  s.files = [
    ".gitignore",
     "History.txt",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "TODO",
     "VERSION",
     "dm-is-published.gemspec",
     "lib/dm-is-published.rb",
     "lib/dm-is-published/is/published.rb",
     "lib/dm-is-published/is/version.rb",
     "spec/integration/published_spec.rb",
     "spec/spec.opts",
     "spec/spec_helper.rb"
  ]
  s.homepage = %q{http://github.com/kematzy/dm-is-published}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.4}
  s.summary = %q{A DataMapper plugin that provides an easy way to add different states to your models.}
  s.test_files = [
    "spec/integration/published_spec.rb",
     "spec/spec_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<dm-core>, [">= 0.10.0"])
      s.add_runtime_dependency(%q<dm-validations>, [">= 0.10.0"])
    else
      s.add_dependency(%q<dm-core>, [">= 0.10.0"])
      s.add_dependency(%q<dm-validations>, [">= 0.10.0"])
    end
  else
    s.add_dependency(%q<dm-core>, [">= 0.10.0"])
    s.add_dependency(%q<dm-validations>, [">= 0.10.0"])
  end
end
