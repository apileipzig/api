require 'test_helper'

class CompanyTest < Test::Unit::TestCase

  def setup
    super

    @api_user = FactoryGirl.create(:user)

    @api_user.permissions << create_permissions_for(Company, :create)
    @api_user.permissions << create_permissions_for(Company, :read)
    @api_user.permissions << create_permissions_for(Company, :update)
    @api_user.permissions << create_permissions_for(Company, :delete)

    @branch = FactoryGirl.create(:branch, :id => 1, :internal_type => "sub_market")
    @company = FactoryGirl.create(:company, :id => 1, :sub_market => @branch)
    FactoryGirl.create(:company, :id => 2, :sub_market => @branch)
  end

  context "A nice user" do
    should "create a company" do
      post "/mediahandbook/companies", FactoryGirl.attributes_for(:company, :sub_market_id => 1)
      assert_status 200
    end

    should "get a list of all companies" do
      get "/mediahandbook/companies"
      assert_status 200
      assert_equal 2, last_result["data"].size
    end

    should "read a company" do
      get "/mediahandbook/companies/1"
      assert_status 200
      assert_equal @company.to_json, last_response.body
    end

    should "update a company" do
      put "/mediahandbook/companies/1", {:name => "updated name"}
      assert_status 200
      get "/mediahandbook/companies/1"
      assert_json(last_response.body) do
        has "name", "updated name"
      end
    end

    should "delete a company" do
      assert_difference('Company.count', -1) do
        delete "/mediahandbook/companies/1"
      end
    end
  end

  #context "A naughty user"
end
