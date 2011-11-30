class BaseTest < Test::Unit::TestCase

  context "GET '/'" do
    setup { get '/' }

    should "return an error" do
      assert_status 400
      assert_body { |json| json.element "error", "Wrong url format." }
    end
  end

end
