# add /lib to loadpath
$LOAD_PATH.unshift File.expand_path("../lib", File.dirname(__FILE__))

ENV['RACK_ENV'] = 'test'

require 'api'
require 'test/unit'
require 'assert_json'
require 'rack/test'
require 'turn'
require 'shoulda-context'
require 'assertions'
require 'factory_girl'
require 'authlogic/test_case'
require 'factories'
require 'database_cleaner'


DatabaseCleaner.strategy = :transaction
DatabaseCleaner.clean_with(:truncation)


class Test::Unit::TestCase
  include Rack::Test::Methods
  include AssertJson
  include Api::Assertions

  def setup
    DatabaseCleaner.start
  end

  def teardown
    DatabaseCleaner.clean
  end

  def app
    Sinatra::Application
  end

  #
  # some dslish test stuff
  #

  def self.test(verb, resource, &block)
    define_method :"test #{verb.to_s.upcase} to \'#{resource}\'" do
      send(verb, [@source, resource].join)
      instance_eval(&block)
    end

  end

  #
  # helper and utility functions for testing
  #

  # creates and returns permissions of the given access type for all columns of the given model 
  def create_permissions_for(klass, access)
    _, source, table = klass.table_name.split("_")
    klass.column_names.map do |cname|
      FactoryGirl.create(:permission, :access => access, :source => source, :table => table, :column => cname)
    end
  end

  # shortcut to the parsed JSON body of the last_response
  def last_result
    JSON.parse(last_response.body)
  end

  # returns the current @user or creates one with default values via FactoryGirl
  def api_user
    @user ||= FactoryGirl.create(:user)
  end

  # returns the api_user's api_key
  def api_key
    api_user && api_user.single_access_token
  end

  # override rack-test's get method in order to add some default values
  def get(url, opts={})
    opts[:api_key] ||= api_key
    super(url, opts)
  end

end
