class DistrictTest < Test::Unit::TestCase

  def setup
    super
    @source = '/district'
    api_user.permissions = create_permissions_for(District, :read)
    FactoryGirl.create(:district, :number => 1, :name => "Zentrum")
    FactoryGirl.create(:district, :number => 2, :name => "West")
  end

  test :get, '/districts' do
    assert_status 200
    assert_equal 2, last_result["data"].size
  end

  test :get, '/districts/1' do
    assert_status 200
    assert_json(last_response.body) do
      has "id", 1
      has "number", 1
      has "name", "Zentrum"
      has "created_at"
      has "updated_at"
    end
  end

end
