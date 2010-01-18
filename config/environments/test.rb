config.cache_classes = true

config.whiny_nils = true

config.action_controller.consider_all_requests_local = true
config.action_controller.perform_caching             = false
config.action_view.cache_template_loading            = true

config.action_controller.allow_forgery_protection    = false

config.action_mailer.delivery_method = :test

config.gem "cucumber-rails", :version => ">= 0.2.3", :lib => false
config.gem "shoulda", :version => ">= 2.10.3"
config.gem "factory_girl", :version => ">= 1.2.2"
config.gem "database_cleaner", :version => ">=0.2.3"
config.gem "rspec", :version => ">= 1.3.0", :lib => false
config.gem "rspec-rails", :version => ">= 1.3.2", :lib => false
