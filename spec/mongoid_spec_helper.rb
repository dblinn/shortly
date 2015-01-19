require 'mongoid'
require 'mongoid-rspec'

RSpec.configure do |conf|
  Mongoid.load!('./mongoid.yml')

  conf.include Mongoid::Matchers, type: :model

  # Clean/Reset Mongoid DB prior to running each test.
  conf.before(:each) do
    Mongoid::Sessions.default.collections.select {|c| c.name !~ /system/ }.each(&:drop)
  end
end
