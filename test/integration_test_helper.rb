# encoding: UTF-8
require 'slimmer/test'
require_relative 'test_helper'
require 'capybara/rails'

class ActionDispatch::IntegrationTest
  include Capybara::DSL

  teardown do
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end

  def assert_page_has_content(text)
    assert page.has_content?(text), %(expected there to be content #{text} in #{page.text.inspect})
  end
end

class JavascriptIntegrationTest < ActionDispatch::IntegrationTest
  setup do
    Capybara.current_driver = Capybara.javascript_driver
  end
end

if Gem.loaded_specs.keys.include?('capybara-webkit')
  require 'capybara-webkit'
  Capybara.javascript_driver = :webkit
else
  Capybara.javascript_driver = :selenium
end
Capybara.default_driver = :rack_test

I18n.load_path += Dir[Rails.root.join(*%w{test fixtures flows locales * *.{rb,yml}})]
