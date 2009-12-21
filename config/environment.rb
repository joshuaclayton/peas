RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION

require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.gem "inherited_resources", :version => ">= 0.9.4"

  config.time_zone = "UTC"
end
