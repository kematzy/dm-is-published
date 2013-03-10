# Add all external dependencies for the plugin here
require 'data_mapper'
require 'active_support/core_ext/object/blank' unless ''.respond_to?(:blank?)

# Require plugin-files
require_relative './is/published'

DataMapper::Model.append_extensions(DataMapper::Is::Published)
DataMapper::Model.append_inclusions(DataMapper::Is::Published::ResourceInstanceMethods)
