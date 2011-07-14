# add /lib to loadpath
$LOAD_PATH.unshift File.expand_path("../lib", File.dirname(__FILE__))

require 'api'
require 'test/unit'
require 'rack/test'

ENV['RACK_ENV'] = 'test'

class BaseTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_test
    get '/'
    assert last_response.status == 400
    assert last_response.body =~ /Wrong url format/
  end

end
