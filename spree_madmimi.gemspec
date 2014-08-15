# encoding: UTF-8
Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_madmimi'
  s.version     = '0.0.1'
  s.summary     = 'Spree extension for Mad Mimi'
  s.description = 'Mad Mimi\'s Spree extension allows you to easily import your product listings and buyer email addresses for a super efficient email integration.'
  s.required_ruby_version = '>= 1.9.3'

  s.author      = 'Maxim Gladkov'
  s.email       = 'maxim@madmimi.com'
  s.homepage    = 'https://github.com/godaddy/spree_madmimi'

  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'spree_core', '~> 2.2.1'

  s.add_dependency 'factory_girl_rails'
  s.add_dependency 'mad_cart'
  s.add_dependency 'httparty'
  s.add_dependency 'omniauth-oauth2'
  s.add_dependency 'omniauth-madmimi'

  s.add_development_dependency 'capybara', '~> 2.1'
  s.add_development_dependency 'coffee-rails'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'factory_girl', '~> 4.4'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'rspec-rails',  '~> 2.13'
  s.add_development_dependency 'sass-rails', '~> 4.0.2'
  s.add_development_dependency 'selenium-webdriver'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'sqlite3'
end
