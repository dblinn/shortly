ENV['RACK_ENV'] ||= 'test'

require 'rspec'
require 'rack/test'
require 'pry'

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
end
