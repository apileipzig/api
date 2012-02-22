class EventTest < Test::Unit::TestCase

  context "[Validations] An Event" do
    should validate_presence_of(:category_id)
    should validate_numericality_of(:category_id)

    should validate_presence_of(:host_id)
    should validate_numericality_of(:host_id)
    should "validate the existence of the host" do
      host = FactoryGirl.create(:host)
      event = FactoryGirl.build(:event, :host_id => host.id)
      assert event.valid?
      # test negative
      assert !Host.exists?(:id => 987654)
      event.host_id = 987654
      assert !event.valid?
    end

    should validate_presence_of(:venue_id)
    should validate_numericality_of(:venue_id)
    should "validate the existence of the venue" do
      venue = FactoryGirl.create(:venue)
      event = FactoryGirl.build(:event, :venue_id => venue.id)
      assert event.valid?
      # test negative
      assert !Venue.exists?(:id => 987654)
      event.venue_id = 987654
      assert !event.valid?
    end

    should validate_presence_of(:name)
    should ensure_length_of(:name).is_at_most(255)

    should validate_presence_of(:description)

    should validate_presence_of(:date_from)
    should "validate the format of date_from" do
      invalid_dates = [
        "12-06-31",
        "2012-6-31",
        "2012-13-31",
        # "2012-12-3",
        "2012-12-42"
      ]
      invalid_dates.each {|testdate| assert_error_on :date_from, Event.new(:date_from => testdate) }
    end

    should "validate the format of date_to" do
      invalid_dates = [
        "12-06-31",
        "2012-6-31",
        "2012-13-31",
        "2012-12-3",
        "2012-12-32"
      ]
      invalid_dates.each do |testdate| 
        event = Event.new :date_to => testdate
        puts testdate
        puts event.inspect
        assert_error_on(:date_to, event) 
      end
    end



  end # of [Validations]

  context "[Ownership] Event#owner" do

    should "respond to owner" do
      assert Event.new.respond_to? :owner
    end

    should "return private events owned by the owner" do
      event_owner  = Factory.create(:user)
      first_event  = Factory.create(:event, :owner => event_owner, :public => false)
      second_event = Factory.create(:event, :public => false)
      assert_equal [first_event], Event.owner(event_owner.single_access_token).all
    end

  end



end
