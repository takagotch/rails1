# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] ||= "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'spec/rails'

Spec::Runner.configure do |config|
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false
  config.fixture_path = RAILS_ROOT + '/spec/fixtures'

  # no need with rspec 1.0.8
  #config.before(:each, :behaviour_type => :controller) do
  #  raise_controller_errors
  #end

  # You can declare fixtures for each behaviour like this:
  #   describe "...." do
  #     fixtures :table_a, :table_b
  #
  # Alternatively, if you prefer to declare them only once, you can
  # do so here, like so ...
  #
  #   config.global_fixtures = :table_a, :table_b
  #
  # If you declare global fixtures, be aware that they will be declared
  # for all of your examples, even those that don't use them.
end

# Time extention for test
class Time
  @@mock_time = nil
  class << self
    now_old = Time.method(:now)
    define_method(:now) do
      if @@mock_time
        @@mock_time
      else
        now_old.call
      end
    end

    def with_mock_time(ts='2007 1/2 3:4:5')
      old_time = @@mock_time
      @@mock_time = Time.parse(ts, Time.local(2007,1,1,0,0,0))
      yield
      @@mock_time = old_time
    end

    def advance(t)
      unless @@mock_time
        raise "advence can be used only in with_mock_time"
      end
      @@mock_time +=(t)
    end
  end
end

