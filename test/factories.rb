FactoryGirl.define do

  factory :user do
    email               "test@example.com"
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

  factory :district do
    sequence(:name)   {|n| "district-#{n}"}
    sequence(:number)
  end

end
