class BaseTest < Test::Unit::TestCase

  context "GET '/'" do
    setup do
      @api_user = FactoryGirl.create(:user)
      get '/'
    end

    should "return an error" do
      assert_status 400
      assert_body { |json| json.element "error", "Wrong url format." }
    end
  end

  context "GET '/some_source/'" do
    setup do
      @api_user = FactoryGirl.create(:user)
      get '/mediahandbook/'
    end

    should "return an error" do
      assert_status 400
      assert_body { |json| json.element "error", "Wrong url format." }
    end
  end

end
