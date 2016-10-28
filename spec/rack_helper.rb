ENV['RACK_ENV'] = 'test'

$LOAD_PATH.unshift File.expand_path('../../app', __FILE__)
require 'racker'
require 'web_game'
require 'capybara/rspec'
require 'capybara-webkit'
require 'show_me_the_cookies'
require 'spec_helper'

app_content = File.read(File.expand_path('../../config.ru', __FILE__))
Capybara.app = eval "Rack::Builder.new {( #{app_content}\n )}"
Capybara.default_driver = :webkit
Capybara.javascript_driver = :webkit

Capybara::Webkit.configure do |config|
  config.allow_url('fonts.googleapis.com')
  config.allow_url('ajax.googleapis.com')
end

Dir['./spec/support/**/*.rb'].sort.each { |f| require f}

RSpec.configure do |config|
  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.include ShowMeTheCookies, type: :feature
end
