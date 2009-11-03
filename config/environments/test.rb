config.cache_classes = true

config.whiny_nils = true

config.action_controller.consider_all_requests_local = true
config.action_controller.perform_caching             = false
config.action_view.cache_template_loading            = true

config.action_controller.allow_forgery_protection    = false

config.action_mailer.delivery_method = :test

config.gem "cucumber", :version => ">= 0.4.2"
config.gem "thoughtbot-shoulda", :lib => "shoulda", :version => ">= 2.10.2"
config.gem "thoughtbot-factory_girl", :lib => "factory_girl", :version => ">= 1.2.2"
config.gem "rspec", :version => ">= 1.2.8", :lib => false
config.gem "rspec-rails", :version => ">= 1.2.7.1", :lib => false
