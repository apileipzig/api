# add /lib to loadpath
$LOAD_PATH.unshift File.expand_path("../lib", File.dirname(__FILE__))

ENV['RACK_ENV'] = 'test'

require 'api'
require 'test/unit'
require 'assert_json'
require 'rack/test'
# require 'turn'
require 'shoulda-context'
require 'assertions'
require 'factory_girl'
require 'authlogic/test_case'
require 'factories'
require 'database_cleaner'


class Test::Unit::TestCase
  include Rack::Test::Methods
  include AssertJson
  include Api::Assertions

  class << self
    def startup
      DatabaseCleaner.strategy = :transaction
      DatabaseCleaner.clean_with(:truncation)
    end

    def shutdown
    end
  end

  def setup
    DatabaseCleaner.start
  end

  def teardown
    DatabaseCleaner.clean
  end

  def app
    Sinatra::Application
  end

end
