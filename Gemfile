source 'https://rubygems.org'
ruby '2.0.0'
gem 'rails', '4.1.4'
gem 'sass-rails', '~> 4.0.3'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0',          group: :doc
gem 'devise'
gem 'devise_invitable'
gem 'figaro', '>= 1.0.0.rc1'
gem 'pundit'
gem 'simple_form'
gem 'therubyracer', :platform=>:ruby
gem 'foundation-rails'
gem 'workflow'
gem 'money-rails'

# Heroku gems...
group :production do
  gem 'rails_12factor'
  gem 'pg'
end

group :development do
  gem 'bazaar' # for generating test data
  gem 'forgery' # for generating test data
  gem 'mysql2'
  gem 'spring'
  gem 'capistrano', '~> 3.0.1'
  gem 'capistrano-bundler'
  gem 'capistrano-rails', '~> 1.1.0'
  gem 'capistrano-rails-console'
  gem 'capistrano-rvm', '~> 0.1.1'
  gem 'guard-bundler'
  gem 'guard-rails'
  gem 'guard-rspec'
  gem 'hub', :require=>nil
  gem 'rails_layout'
  gem 'rb-fchange', :require=>false
  gem 'rb-fsevent', :require=>false
  gem 'rb-inotify', :require=>false
end

group :development, :test do
  gem 'factory_girl_rails'
  gem 'rspec-rails'
end

group :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'faker'
  gem 'launchy'
  gem 'selenium-webdriver'
end
