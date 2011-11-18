class DistrictTest < Test::Unit::TestCase

  context "GET '/districts'" do
    setup do
      @user = FactoryGirl.create(:user)

      permissions = District.column_names.map do |cname| 
        FactoryGirl.create(:permission, :access => "read", :table => "districts", :column => cname, :source => "district")
      end

      @user.permissions = permissions

      FactoryGirl.create(:district, :number => 1, :name => "Zentrum")

      get '/district/districts', :api_key => @user.single_access_token
    end

    should "be successful" do
      assert_status 200
    end

    should "return a list of all districts" do
      doc = JSON.parse(last_response.body)
      puts doc.inspect
      assert_equal 1, doc['data'].size
    end
  end

end
