require 'test_helper'

class PropertyTest < Test::Unit::TestCase

  def setup
    super
    @source = '/calendar'

    @user = Factory.create(:user)
    @user.permissions = create_permissions_for(Event, :read)

    @another_user = Factory.create(:user)
    @another_user.permissions = create_permissions_for(Event, :read)

    Factory.create(:event, :id => 1, :owner => @user)
    Factory.create(:event, :id => 2, :owner => @user, :public => false)
    Factory.create(:event, :id => 3, :owner => @another_user)
    Factory.create(:event, :id => 4, :owner => @another_user, :public => false)
  end

  test :get, '/events', "returns only own and public events" do
    assert_status 200
    assert_equal 3, last_result["data"].size
  end

  test :get, '/events/1', "returns own public event" do
    assert_status 200
    assert_json(last_response.body) do
      has "id", 1
      has "public", true
      has "owner_id", @user.id
    end
  end

  test :get, '/events/2', "returns own private event" do
    assert_status 200
    assert_json(last_response.body) do
      has "id", 2
      has "public", false
      has "owner_id", @user.id
    end
  end

  test :get, '/events/3', "returns public event from other user" do
    assert_status 200
    assert_json(last_response.body) do
      has "id", 3
      has "public", false
      has "owner_id", @another_user.id
    end
  end

  test :get, '/events/4', "doesn't return a private event from other user" do
    assert_status 404
    assert_body { |json| json.element "error", "Not found." }
  end

  test :put, 'events/1', "updates own public event" do
    # ...
    assert true
  end
end
