FactoryGirl.define do

  factory :user do
    sequence(:email)   {|n| "test-#{n}@example.com"}
    #password_salt       { Authlogic::Random.hex_token }
    #crypted_password    { Authlogic::CryptoProviders::Sha512.encrypt("test1234" + password_salt) }
    single_access_token { Authlogic::Random.friendly_token }
    persistence_token   { Authlogic::Random.hex_token }
    perishable_token    { Authlogic::Random.friendly_token }
    password "test"
    password_confirmation "test"
  end

  factory :permission do
    # nothing
  end

  ########### MEDIAHANDBOOK

  factory :branch do
    sequence(:name) {|n| "name-#{n}"}
    association :owner, :factory => :user
  end

  ########### CALENDAR

  factory :host do
    sequence(:first_name) {|n| "first_name-#{n}"}
    sequence(:last_name) {|n| "last_name-#{n}"}
    association :owner, :factory => :user
  end

  factory :venue do
    sequence(:name) {|n| "name-#{n}"}
    association :owner, :factory => :user
  end

  factory :event do
    sequence(:name) {|n| "event-#{n}"}
    sequence(:description) {|n| "description-#{n}"}
    date_from Time.now.strftime("%Y-%m-%d")
    association :category, :factory => :branch, :internal_type => 'sub_market'
    host
    venue
    association :owner, :factory => :user
  end

  ########### DISTRICT

  factory :district do
    sequence(:name)   {|n| "district-#{n}"}
    sequence(:number)
    association :owner, :factory => :user
  end
end
