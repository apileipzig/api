require 'test_helper'

class PropertyTest < Test::Unit::TestCase

  def setup
    super

    @user = Factory.create(:user)
    @user.permissions << create_permissions_for(Event, :read)
    @user.permissions << create_permissions_for(Event, :update)
    @user.permissions << create_permissions_for(Event, :delete)

    @another_user = Factory.create(:user)
    @another_user.permissions = create_permissions_for(Event, :read)

    Factory.create(:event, :id => 1, :owner => @user)
    Factory.create(:event, :id => 2, :owner => @user, :public => false)
    Factory.create(:event, :id => 3, :owner => @another_user)
    Factory.create(:event, :id => 4, :owner => @another_user, :public => false)
  end

  context "The owner of an event" do
    setup {@api_user = @user}

    should "see all own and public events" do
      get "/calendar/events"
      assert_status 200
      assert_equal 3, last_result["data"].size
    end

    should "see his own public event" do
      get "/calendar/events/1"
      assert_status 200
      assert_json(last_response.body) do
        has "id", 1
        has "public", true
        has "owner_id", @user.id
      end
    end

    should "see an event even if its private" do
      get "/calendar/events/2"
      assert_status 200
      assert_json(last_response.body) do
        has "id", 2
        has "public", false
        has "owner_id", @user.id
      end
    end

    should "see a public event from another user" do
      get "/calendar/events/3"
      assert_status 200
      assert_json(last_response.body) do
        has "id", 3
        has "public", false
        has "owner_id", @another_user.id
      end
    end

    should "not see a private event from another user" do
      get "/calendar/events/4"
      assert_status 404
      assert_body { |json| json.element "error", "Not found." }
    end

    should "update his own public event" do
      put "/calendar/events/1", {:name => "updated title"}
      assert_status 200
    end

    should "delete his own public event" do
      delete "/calendar/events/1"
      assert_status 200
    end
  end

  context "A regular user" do
    setup do
      user = Factory.create(:user)
      user.permissions << create_permissions_for(Event, :read)
      user.permissions << create_permissions_for(Event, :update)
      user.permissions << create_permissions_for(Event, :delete)
      @api_user = user
    end

    should "see only public events" do
      get '/calendar/events'
      assert_status 200
      assert_equal 2, last_result["data"].size
      last_result["data"].each do |j|
        assert_equal j["public"], true
      end
    end

    should "not update another users public event" do
      put '/calendar/events/1'
      assert_status 403
      assert_body { |json| json.element "error", "No permission(s) to do this." }
    end

    should "not update another users private event" do
      put '/calendar/events/2'
      assert_status 404
      assert_body { |json| json.element "error", "Not found." }
    end

    should "not delete another users public event" do
      delete '/calendar/events/1'
      assert_status 403
      assert_body { |json| json.element "error", "No permission(s) to do this." }
    end

    should "not delete another users private event" do
      delete '/calendar/events/2'
      assert_status 404
      assert_body { |json| json.element "error", "Not found." }
    end
  end
end
