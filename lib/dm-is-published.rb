# Needed to import datamapper and other gems
# require 'rubygems' # read [ http://gist.github.com/54177 ] to understand why this line is commented out
require 'pathname'

# Add all external dependencies for the plugin here
# gem 'dm-core', '~> 0.10.0'
require 'dm-core'
# gem 'dm-validations', '~> 0.10.0'
require 'dm-validations'

# Require plugin-files
require Pathname(__FILE__).dirname.expand_path / 'dm-is-published' / 'is' / 'published.rb'

DataMapper::Model.append_extensions(DataMapper::Is::Published)
DataMapper::Model.append_inclusions(DataMapper::Is::Published::ResourceInstanceMethods)
