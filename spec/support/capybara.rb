#require 'capybara/webkit/matchers'

Capybara.configure do |config|
  config.asset_host = 'http://localhost:3001'
  config.javascript_driver = :webkit
  #config.javascript_driver = :webkit_debug
  #config.javascript_driver = :selenium
end

RSpec.configure do |config|
#  config.include(Capybara::Webkit::RspecMatchers, type: :feature)
end
