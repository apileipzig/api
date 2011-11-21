class DistrictTest < Test::Unit::TestCase

  context "GET '/districts'" do
    setup do
      api_user.permissions = create_permissions_for(District, :read)
      FactoryGirl.create(:district, :number => 1, :name => "Zentrum")
      get '/district/districts'
    end

    should "be successful" do
      assert_status 200
    end

    should "return a list of all districts" do
      assert_equal 1, last_data.size
    end
  end

end
