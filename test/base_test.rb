require File.expand_path(File.dirname(__FILE__) + '/config.rb')
require "api"

context "Testing the API base" do
  context "retrieving the index" do
    setup { get "/" }
    asserts_response_status 400
    asserts_json_response("text/javascript;charset=utf-8") { {:error => "Wrong url format."}.to_json }
  end
end
