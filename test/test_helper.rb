# add /lib to loadpath
$LOAD_PATH.unshift File.expand_path("../lib", File.dirname(__FILE__))

require 'api'
require 'test/unit'
require 'assert_json'
require 'rack/test'
require 'turn'
require 'shoulda-context'
require 'assertions'

ENV['RACK_ENV'] = 'test'

class Test::Unit::TestCase
  include Rack::Test::Methods
  include AssertJson
  include Api::Assertions

  def app
    Sinatra::Application
  end

end
