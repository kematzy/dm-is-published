# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{dm-is-published}
  s.version = "0.0.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["kematzy"]
  s.date = %q{2010-06-09}
  s.description = %q{A DataMapper plugin that provides an easy way to add different states to your models.}
  s.email = %q{kematzy@gmail.com}
  s.extra_rdoc_files = [
    "History.rdoc",
     "LICENSE",
     "README.rdoc",
     "TODO"
  ]
  s.files = [
    ".gitignore",
     "History.rdoc",
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
     "spec/spec_helper.rb"
  ]
  s.homepage = %q{http://github.com/kematzy/dm-is-published}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{A DataMapper plugin that provides an easy way to add different states to your models.}
  s.test_files = [
    "spec/integration/published_spec.rb",
     "spec/spec_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<dm-core>, ["~> 1.0.0"])
      s.add_development_dependency(%q<rspec>, ["~> 1.3"])
      s.add_development_dependency(%q<dm-migrations>, ["~> 1.0.0"])
      s.add_development_dependency(%q<dm-validations>, ["~> 1.0.0"])
    else
      s.add_dependency(%q<dm-core>, ["~> 1.0.0"])
      s.add_dependency(%q<rspec>, ["~> 1.3"])
      s.add_dependency(%q<dm-migrations>, ["~> 1.0.0"])
      s.add_dependency(%q<dm-validations>, ["~> 1.0.0"])
    end
  else
    s.add_dependency(%q<dm-core>, ["~> 1.0.0"])
    s.add_dependency(%q<rspec>, ["~> 1.3"])
    s.add_dependency(%q<dm-migrations>, ["~> 1.0.0"])
    s.add_dependency(%q<dm-validations>, ["~> 1.0.0"])
  end
end

