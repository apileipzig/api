# add /lib to loadpath
$:.unshift File.expand_path("../lib", File.dirname(__FILE__))

env = ENV['RACK_ENV'] = "test"

require 'bundler'
Bundler.require(:default, env.to_sym)
require 'api'
require 'assertions'
require 'factories'

DatabaseCleaner.strategy = :transaction
DatabaseCleaner.clean_with(:truncation)

class Test::Unit::TestCase
  include Rack::Test::Methods
  include AssertJson
  include Api::Assertions
  include ActiveSupport::Testing::Assertions

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

  def self.test(verb, resource, details=nil, &block)
    name = ["test", "#{verb.to_s.upcase} to '#{resource}'", details].compact.join(" ")
    raise "A method with name: '#{name}' is already defined" if method_defined?(name)

    define_method name do
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

  # override rack-test's get method in order to add some default values
  def post(url, opts={})
    opts[:api_key] ||= @api_user.api_key
    super(url, opts)
  end

  def get(url, opts={})
    opts[:api_key] ||= @api_user.api_key
    super(url, opts)
  end

  def put(url, opts={})
    opts[:api_key] ||= @api_user.api_key
    super(url, opts)
  end

  def delete(url, opts={})
    opts[:api_key] ||= @api_user.api_key
    super(url, opts)
  end

end
