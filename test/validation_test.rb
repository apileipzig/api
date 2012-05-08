#encoding: utf-8
require 'test_helper'

class ValidationTest < Test::Unit::TestCase
  def setup
    super

    @api_user = FactoryGirl.create(:user)

    @api_user.permissions << create_permissions_for(Host, :create)
    @api_user.permissions << create_permissions_for(Host, :read)
    @api_user.permissions << create_permissions_for(Host, :update)
    @api_user.permissions << create_permissions_for(Host, :delete)

    @special_string = '!"§$%&/()=?`{[]}\ ¸+#-.,öäü;:_\'*><|éè'
  end

  context 'The API' do
    should 'allow special chars' do
      assert_difference('Host.count', 1) do
        post '/calendar/hosts', FactoryGirl.attributes_for(:host, :first_name => @special_string)
      end
      assert_status 200
    end

    should 'return special chars correctly' do
      post '/calendar/hosts', FactoryGirl.attributes_for(:host, :first_name => @special_string)
      get '/calendar/hosts/1'
      assert_json(last_response.body) do
        has 'first_name', @special_string
      end
    end

    %w[limit offset].each do |p|
      should "allow only digits in #{p} param" do
        get '/calendar/hosts', p.to_sym => 10
        assert_status 200
      end

      should "deny any non digit in #{p} param" do
        get 'calendar/hosts', p.to_sym => '1A0'
        assert_status 400
        assert_body { |json| json.element "error", "Wrong parameter format in [#{p}]." }
      end
    end
  end
end
