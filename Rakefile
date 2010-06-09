require 'rubygems' 
require 'rake'

begin
  require 'jeweler'
  
  Jeweler::Tasks.new do |gem|
    gem.name              = "dm-is-published"
    # gem.version           = IO.read('VERSION') || '0.0.0'
    gem.summary           = %Q{A DataMapper plugin that provides an easy way to add different states to your models.}
    gem.description       = gem.summary
    gem.email             = "kematzy@gmail.com"
    gem.homepage          = 'http://github.com/kematzy/dm-is-published'
    gem.authors           = ["kematzy"]
    gem.extra_rdoc_files  = %w[ README.rdoc LICENSE TODO History.rdoc ]
    
    gem.add_dependency 'dm-core',   '~> 1.0.0'
    
    gem.add_development_dependency 'rspec',          '~> 1.3'
    gem.add_development_dependency 'dm-migrations', '~> 1.0.0'
    gem.add_development_dependency 'dm-validations', '~> 1.0.0'
  end
  
  Jeweler::GemcutterTasks.new
  
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_opts = ["--color", "--format", "nested", "--require", "spec/spec_helper.rb"]
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_opts = ["--color", "--format", "nested", "--require", "spec/spec_helper.rb"]
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end


task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? IO.read('VERSION').chomp : "[Unknown]"
  
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "dm-is-published #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end


desc 'Build the rdoc HTML Files'
task :docs do
  version = File.exist?('VERSION') ? IO.read('VERSION').chomp : "[Unknown]" 
  
  sh "sdoc -N --title 'DM::Is::Published v#{version}' lib/dm-is-published README.rdoc"
end

namespace :docs do
  
  desc 'Remove rdoc products'
  task :remove => [:clobber_rdoc] do 
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

