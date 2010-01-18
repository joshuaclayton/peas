require 'lib/leftright/version'

Gem::Specification.new do |gem|
  gem.name    = 'leftright'
  gem.version = LeftRight::VERSION

  gem.author, gem.email = 'Jordi Bunster', 'jordi@bunster.org'

  gem.summary     = "Cool replacement for Test::Unit's TestRunner"
  gem.description = %{ leftright is kind of like the redgreen gem. It makes
    passing tests look green, exceptions yellow, and failures red. It also
    has a few features that make your workflow a bit faster (see README).
  }.strip!.gsub! /\s+/, ' '

  gem.has_rdoc = false

  gem.date  = Date.today
  gem.files = %w[
    MIT-LICENSE
    README.rdoc
    WHATSNEW
    leftright.gemspec
    lib
    lib/leftright.rb
    lib/leftright
    lib/leftright/autorun.rb
    lib/leftright/color.rb
    lib/leftright/runner.rb
    lib/leftright/version.rb
  ]
end