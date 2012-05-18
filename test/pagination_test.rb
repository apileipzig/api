#encoding: utf-8
require 'test_helper'

class PaginationTest < Test::Unit::TestCase
  def setup
    super

    @api_user = FactoryGirl.create(:user)

    @api_user.permissions << create_permissions_for(Company, :read)

    10.times do
      FactoryGirl.create(:company)
    end
  end

  context 'A Response' do
    should 'not have a paging object if no limit parameter is set' do
      get '/mediahandbook/companies'
      #puts last_response.inspect
      #assert_status 200
      #assert_nil last_result['paging']
    end

    [0,1,9,10,11].each do |n|
      should "have #{n <= 10 ? n : 10} data elements if limit parameter is set to #{n}" do
        get '/mediahandbook/companies', :limit => n
        assert_status 200
        assert_equal n <= 10 ? n : 10, last_result["data"].size
      end
    end

    should 'not have a paging object if limit is bigger then the amount of data elements' do
      get '/mediahandbook/companies', :limit => 20
      assert_status 200
      assert_nil last_result['paging']
    end

    should 'not have a paging object if limit is equal then the amount of data elements' do
      get '/mediahandbook/companies', :limit => 10
      assert_status 200
      assert_nil last_result['paging']
    end

    should 'have a paging object if limit is smaller then the amount of data elements' do
      get '/mediahandbook/companies', :limit => 8
      assert_status 200
      assert last_result['paging']
    end
  end

  context 'The paging object' do
    should 'have a next field' do
      get '/mediahandbook/companies', :limit => 8
      assert_status 200
      assert last_result['paging']['next']
    end

    should 'not have a previous field if no offset parameter is set' do
      get '/mediahandbook/companies', :limit => 8
      assert_status 200
      assert last_result['paging']
      assert_nil last_result['paging']['previous']
    end

    should 'have a previous field if offset parameter is set' do
      get '/mediahandbook/companies', :limit => 1, :offset => 2
      assert_status 200
      assert last_result['paging']['previous']
    end

    should 'not have a next field if there is no next page' do
      get '/mediahandbook/companies', :limit => 5, :offset => 5
      assert_status 200
      assert last_result['paging']
      assert_nil last_result['paging']['next']
    end

    should 'not have a previous field if there is no previous page' do
      get '/mediahandbook/companies', :limit => 1, :offset => 0
      assert_status 200
      assert last_result['paging']
      assert_nil last_result['paging']['previous']
    end
  end

  context 'The next field' do
    should 'have the correct request url' do
      get '/mediahandbook/companies', :limit => 5, :offset => 2
      assert_status 200
      assert_equal "#{API_URL}mediahandbook/companies?api_key=#{@api_user.single_access_token}&limit=5&offset=7", last_result['paging']['next']
    end

    should 'have the correct request url when searching' do
      #trailing ? is a hack for testing
      get '/mediahandbook/companies/search?', :q => 'a', :limit => 5, :offset => 2
      assert_status 200
      assert_equal "#{API_URL}mediahandbook/companies/search?api_key=#{@api_user.single_access_token}&q=a&limit=5&offset=7", last_result['paging']['next']
    end
  end

  context 'The previous field' do
    should 'have the correct request url' do
      get '/mediahandbook/companies', :limit => 2, :offset => 5
      assert_status 200
      assert_equal "#{API_URL}mediahandbook/companies?api_key=#{@api_user.single_access_token}&limit=2&offset=3", last_result['paging']['previous']
    end

    should 'have the correct request url when searching' do
      #trailing ? is a hack for testing
      get '/mediahandbook/companies/search?', :q => 'a', :limit => 2, :offset => 5
      #assert_status 200
      puts last_response.inspect
      assert_equal "#{API_URL}mediahandbook/companies/search?api_key=#{@api_user.single_access_token}&q=a&limit=2&offset=3", last_result['paging']['previous']
    end
  end
end
