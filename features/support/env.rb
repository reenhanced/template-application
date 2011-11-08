require 'cucumber/rails'
require 'cucumber/rails/rspec'
require 'cucumber/rails/world'
require 'cucumber/web/tableish'
require 'capybara/cucumber'
require 'capybara/session'
require 'ruby-debug'

Capybara.default_selector = :css

ActionController::Base.allow_rescue = false

DatabaseCleaner.strategy = :truncation

Capybara.ignore_hidden_elements = false
Capybara.save_and_open_page_path = 'tmp'

require 'capybara-webkit'
Capybara.javascript_driver = :webkit

rails_app = Capybara.app

Capybara.app = lambda do |env|
  rails_app.call(env)
end

After do |scenario|
  if(scenario.failed?)
    puts
    puts "*"*80
    puts scenario.exception.message
    puts scenario.backtrace_line
    puts "*"*80
  end
end
