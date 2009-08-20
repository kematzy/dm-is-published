require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "dm-is-published"
    gem.version = IO.read('VERSION') || '0.0.0'
    gem.summary = %Q{A DataMapper plugin that provides an easy way to add different states to your models.}
    # gem.description = gem.summary
    gem.description = IO.read('README.rdoc') || gem.summary
    gem.email = "kematzy@gmail.com"
    gem.homepage = "http://github.com/kematzy/dm-is-published"
    gem.authors = ["kematzy"]
    gem.extra_rdoc_files = %w[ README.rdoc LICENSE TODO History.rdoc ]
    gem.add_dependency('dm-core', '>= 0.10.0')
    gem.add_dependency('dm-validations', '>= 0.10.0')
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end

rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end


task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""
  
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "dm-is-published #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end


desc 'Build the rdoc HTML Files'
task :docs do
  version = File.exist?('VERSION') ? File.read('VERSION') : ""  
  sh "sdoc -N --title 'DM::Is::Published v#{version}' lib/dm-is-published README.rdoc"
end

namespace :docs do
  
  desc 'Remove rdoc products'
  task :remove => [:clobber_rdoc] do |variable|
    sh "rm -rf doc"
  end
  
  desc 'Force a rebuild of the RDOC files'
  task :rebuild => [:docs]
  
  desc 'Build docs, and open in browser for viewing (specify BROWSER)'
  task :open => [:docs] do
    browser = ENV["BROWSER"] || "safari"
    sh "open -a #{browser} doc/index.html"
  end
  
end

