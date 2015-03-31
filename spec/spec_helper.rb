require 'rack/test'
require 'rspec'
require 'pry'
require 'capybara'
require 'capybara/dsl'
require 'sinatra'

# can't reuse APP_ROOT bc environment not loaded
root = Pathname.new(File.expand_path('../../', __FILE__))

Dir["#{root}/spec/support/**/*.rb"].each {|file| require file}

ENV['RACK_ENV'] = 'test'

module RSpecMixin
  include Rack::Test::Methods
  def app
    Sinatra::Application
  end
end

# set environment to test for database logic
Sinatra::Base.set :environment, :test
Sinatra::Base.set :views, File.join(root, "app", "views")

# load up the application
require_relative "../config/environment"

Capybara.app = Sinatra::Application.new

RSpec.configure do |config|
  config.include RSpecMixin
  config.include Capybara::DSL
end

