require 'test_helper'

class XmlTest < Test::Unit::TestCase

  def setup
    super

    @user = Factory.create(:user)
    @user.permissions << create_permissions_for(Event, :create)
  end

  context "A regular user" do
    setup {@api_user = @user}

    should "create an event with format=xml" do
      post 'calendar/events', {:format => "xml"}.merge!(FactoryGirl.attributes_for(
        :event,
        :host_id => Factory.create(:host).id,
        :venue_id => Factory.create(:venue).id,
        :category_id => Factory.create(:branch, :internal_type => "sub_market").id
      ))
      assert_status 200
    end
  end
end
