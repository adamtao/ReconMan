source 'https://rubygems.org'
ruby '2.7.2'
gem 'rails', '< 6'
gem 'sprockets', '< 4'
gem 'responders', '~> 2.0'
gem 'sass-rails'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails' #, '~> 4.1.0'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'jbuilder', '~> 2.0'
gem 'devise'
gem 'devise_invitable'
gem 'figaro', '>= 1.0.0.rc1'
gem 'pundit'
gem 'ace-rails-ap'
gem 'simple_form'
gem 'liquid'
#gem 'therubyracer', :platform=>:ruby
gem 'foundation-rails', '5.5.1' #, '5.5.3' has a magellan bug
gem 'kaminari'
gem 'workflow', '< 2.0'
gem 'money-rails'
gem 'ransack'
gem "rabl"
gem "RedCloth"
gem "redcloth-rails"
gem 'unicorn'
gem 'addressable'
gem 'paperclip'
#gem 'aws-sdk', '~> 2.3'
gem 'aws-sdk-s3'
gem 'active_attr'
gem 'to_xls'
gem 'exception_notification'
gem 'pg'

# Heroku gems...
group :production do
  gem 'rails_12factor'
end

group :development do
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'guard-bundler'
  gem 'guard-rails'
  gem 'guard-rspec'
  gem 'rb-fchange', :require=>false
  gem 'rb-fsevent', :require=>false
  gem 'rb-inotify', :require=>false
end

group :development, :test do
  gem 'bazaar' # for generating test data
  gem 'forgery' # for generating test data
  gem 'factory_bot_rails'
  gem 'rspec-rails'
end

group :test do
  gem 'capybara'
  gem 'webdrivers'
  gem 'database_cleaner'
  gem 'simplecov', require: false
  gem 'faker'
  gem 'launchy'
  gem 'selenium-webdriver'
  # This brings back the 'assigns' method I used a lot in testing which DHH
  # now discourages. But, requiring it here breaks other tests. So I do the
  # require in spec/rails_helper.rb
  gem 'rails-controller-testing', require: false
end
