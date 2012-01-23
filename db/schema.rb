# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20111202182217) do

  create_table "data_calendar_events", :force => true do |t|
    t.integer  "category_id"
    t.integer  "host_id"
    t.integer  "venue_id"
    t.date     "date_from"
    t.time     "time_from"
    t.date     "date_to"
    t.time     "time_to"
    t.string   "name"
    t.text     "description"
    t.string   "url"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.string   "image_url"
    t.string   "document_url"
    t.integer  "owner_id"
    t.boolean  "public",       :default => true
  end

  create_table "data_calendar_hosts", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone"
    t.string   "mobile"
    t.string   "url"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
    t.string   "company"
    t.string   "street"
    t.integer  "housenumber"
    t.string   "housenumber_additional"
    t.string   "postcode"
    t.string   "city"
    t.string   "email"
    t.string   "fax"
    t.text     "comment"
  end

  create_table "data_calendar_venues", :force => true do |t|
    t.string   "name"
    t.string   "street"
    t.integer  "housenumber"
    t.string   "housenumber_additional"
    t.string   "postcode"
    t.string   "city"
    t.string   "phone"
    t.text     "description"
    t.string   "url"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
  end

  create_table "data_district_districts", :force => true do |t|
    t.integer  "number"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "data_district_ihkcompanies", :force => true do |t|
    t.integer  "district_id"
    t.integer  "companies_total"
    t.integer  "agriculture_forestry_fishery"
    t.integer  "mining"
    t.integer  "processing_trade"
    t.integer  "power_supply"
    t.integer  "water_supply_and_waste_management"
    t.integer  "building_contruction"
    t.integer  "vehicle_maintenance"
    t.integer  "traffic_and_warehousing"
    t.integer  "hotel_and_restaurant_industry"
    t.integer  "information_and_communication"
    t.integer  "financial_and_insurance_services"
    t.integer  "housing"
    t.integer  "scientific_and_technical_services"
    t.integer  "other_economic_services"
    t.integer  "public_administration"
    t.integer  "education"
    t.integer  "health_care"
    t.integer  "artistry_and_entertainment"
    t.integer  "other_services"
    t.integer  "private_services"
    t.integer  "extraterritorial_organisations"
    t.integer  "other"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  create_table "data_district_statistics", :force => true do |t|
    t.integer  "district_id"
    t.float    "area"
    t.integer  "inhabitants_total"
    t.integer  "male_total"
    t.integer  "male_0_4"
    t.integer  "male_5_9"
    t.integer  "male_10_14"
    t.integer  "male_15_19"
    t.integer  "male_20_24"
    t.integer  "male_25_29"
    t.integer  "male_30_34"
    t.integer  "male_35_39"
    t.integer  "male_40_44"
    t.integer  "male_45_49"
    t.integer  "male_50_54"
    t.integer  "male_55_59"
    t.integer  "male_60_64"
    t.integer  "male_65_69"
    t.integer  "male_70_74"
    t.integer  "male_75_79"
    t.integer  "male_80"
    t.integer  "female_total"
    t.integer  "female_0_4"
    t.integer  "female_5_9"
    t.integer  "female_10_14"
    t.integer  "female_15_19"
    t.integer  "female_20_24"
    t.integer  "female_25_29"
    t.integer  "female_30_34"
    t.integer  "female_35_39"
    t.integer  "female_40_44"
    t.integer  "female_45_49"
    t.integer  "female_50_54"
    t.integer  "female_55_59"
    t.integer  "female_60_64"
    t.integer  "female_65_69"
    t.integer  "female_70_74"
    t.integer  "female_75_79"
    t.integer  "female_80"
    t.integer  "family_status_single"
    t.integer  "family_status_married"
    t.integer  "family_status_widowed"
    t.integer  "family_status_divorced"
    t.integer  "family_status_unknown"
    t.integer  "citizenship_germany"
    t.integer  "citizenship_albania"
    t.integer  "citizenship_bosnia_and_herzegovina"
    t.integer  "citizenship_belgium"
    t.integer  "citizenship_bulgaria"
    t.integer  "citizenship_denmark"
    t.integer  "citizenship_estonia"
    t.integer  "citizenship_finland"
    t.integer  "citizenship_france"
    t.integer  "citizenship_croatia"
    t.integer  "citizenship_slovenia"
    t.integer  "citizenship_serbia_and_montenegro"
    t.integer  "citizenship_serbia_and_kosovo"
    t.integer  "citizenship_greece"
    t.integer  "citizenship_ireland"
    t.integer  "citizenship_iceland"
    t.integer  "citizenship_italy"
    t.integer  "citizenship_latvia"
    t.integer  "citizenship_montenegro"
    t.integer  "citizenship_lithuania"
    t.integer  "citizenship_luxembourg"
    t.integer  "citizenship_macedonia"
    t.integer  "citizenship_malta"
    t.integer  "citizenship_moldova"
    t.integer  "citizenship_netherlands"
    t.integer  "citizenship_norway"
    t.integer  "citizenship_kosovo"
    t.integer  "citizenship_austria"
    t.integer  "citizenship_poland"
    t.integer  "citizenship_portugal"
    t.integer  "citizenship_romania"
    t.integer  "citizenship_slovakia"
    t.integer  "citizenship_sweden"
    t.integer  "citizenship_switzerland"
    t.integer  "citizenship_russian_federation"
    t.integer  "citizenship_spain"
    t.integer  "citizenship_czechoslovakia"
    t.integer  "citizenship_turkey"
    t.integer  "citizenship_czech_republic"
    t.integer  "citizenship_hungary"
    t.integer  "citizenship_ukraine"
    t.integer  "citizenship_united_kingdom"
    t.integer  "citizenship_belarus"
    t.integer  "citizenship_serbia"
    t.integer  "citizenship_cyprus"
    t.integer  "citizenship_algeria"
    t.integer  "citizenship_angola"
    t.integer  "citizenship_eritrea"
    t.integer  "citizenship_ethopia"
    t.integer  "citizenship_botswana"
    t.integer  "citizenship_benin"
    t.integer  "citizenship_cote_d_ivoire"
    t.integer  "citizenship_nigeria"
    t.integer  "citizenship_zimbabwe"
    t.integer  "citizenship_gambia"
    t.integer  "citizenship_ghana"
    t.integer  "citizenship_mauritania"
    t.integer  "citizenship_cap_verde"
    t.integer  "citizenship_kenya"
    t.integer  "citizenship_republic_of_congo"
    t.integer  "citizenship_democratic_republic_of_congo"
    t.integer  "citizenship_liberia"
    t.integer  "citizenship_libya"
    t.integer  "citizenship_madagascar"
    t.integer  "citizenship_mali"
    t.integer  "citizenship_morocco"
    t.integer  "citizenship_mauritius"
    t.integer  "citizenship_mozambique"
    t.integer  "citizenship_niger"
    t.integer  "citizenship_malawi"
    t.integer  "citizenship_zambia"
    t.integer  "citizenship_burkina_faso"
    t.integer  "citizenship_guinea_bissau"
    t.integer  "citizenship_guinea"
    t.integer  "citizenship_cameroon"
    t.integer  "citizenship_south_africa"
    t.integer  "citizenship_rwanda"
    t.integer  "citizenship_namibia"
    t.integer  "citizenship_senegal"
    t.integer  "citizenship_seychelles"
    t.integer  "citizenship_sierra_leone"
    t.integer  "citizenship_somalia"
    t.integer  "citizenship_equatorial_guinea"
    t.integer  "citizenship_sudan"
    t.integer  "citizenship_tanzania"
    t.integer  "citizenship_togo"
    t.integer  "citizenship_tunisia"
    t.integer  "citizenship_uganda"
    t.integer  "citizenship_egypt"
    t.integer  "citizenship_unknown"
    t.integer  "citizenship_antigua_and_barbuda"
    t.integer  "citizenship_argentinia"
    t.integer  "citizenship_bahamas"
    t.integer  "citizenship_bolvia"
    t.integer  "citizenship_brazil"
    t.integer  "citizenship_chile"
    t.integer  "citizenship_costa_rica"
    t.integer  "citizenship_dominican_republic"
    t.integer  "citizenship_ecuador"
    t.integer  "citizenship_el_salvador"
    t.integer  "citizenship_guatemala"
    t.integer  "citizenship_haiti"
    t.integer  "citizenship_honduras"
    t.integer  "citizenship_canada"
    t.integer  "citizenship_colombia"
    t.integer  "citizenship_cuba"
    t.integer  "citizenship_mexico"
    t.integer  "citizenship_nicaragua"
    t.integer  "citizenship_jamaica"
    t.integer  "citizenship_panama"
    t.integer  "citizenship_peru"
    t.integer  "citizenship_uruguay"
    t.integer  "citizenship_venezuela"
    t.integer  "citizenship_united_states"
    t.integer  "citizenship_trinidad_and_tobago"
    t.integer  "citizenship_unknown2"
    t.integer  "citizenship_yemen"
    t.integer  "citizenship_armenia"
    t.integer  "citizenship_afghanistan"
    t.integer  "citizenship_bahrain"
    t.integer  "citizenship_azerbaijan"
    t.integer  "citizenship_bhutan"
    t.integer  "citizenship_myanmar"
    t.integer  "citizenship_georgia"
    t.integer  "citizenship_sri_lanka"
    t.integer  "citizenship_vietnam"
    t.integer  "citizenship_north_korea"
    t.integer  "citizenship_india"
    t.integer  "citizenship_indonesia"
    t.integer  "citizenship_iraq"
    t.integer  "citizenship_iran"
    t.integer  "citizenship_israel"
    t.integer  "citizenship_japan"
    t.integer  "citizenship_kazakhstan"
    t.integer  "citizenship_jordan"
    t.integer  "citizenship_cambodia"
    t.integer  "citizenship_kuwait"
    t.integer  "citizenship_laos"
    t.integer  "citizenship_kyrgyzstan"
    t.integer  "citizenship_lebanon"
    t.integer  "citizenship_maldives"
    t.integer  "citizenship_oman"
    t.integer  "citizenship_mongolia"
    t.integer  "citizenship_nepal"
    t.integer  "citizenship_bangladesh"
    t.integer  "citizenship_pakistan"
    t.integer  "citizenship_phillipines"
    t.integer  "citizenship_taiwan"
    t.integer  "citizenship_south_korea"
    t.integer  "citizenship_tadzhikistan"
    t.integer  "citizenship_turkmenistan"
    t.integer  "citizenship_saudia_arabia"
    t.integer  "citizenship_singapore"
    t.integer  "citizenship_syria"
    t.integer  "citizenship_thailand"
    t.integer  "citizenship_uzbekistan"
    t.integer  "citizenship_china"
    t.integer  "citizenship_malaysia"
    t.integer  "citizenship_remainig_asia"
    t.integer  "citizenship_australia"
    t.integer  "citizenship_solomon_islands"
    t.integer  "citizenship_new_zealand"
    t.integer  "citizenship_samoa"
    t.integer  "citizenship_inapplicable"
    t.integer  "citizenship_unknown3"
    t.integer  "citizenship_not_specified"
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
    t.integer  "religion_protestant"
    t.integer  "religion_catholic"
    t.integer  "religion_other_or_none"
  end

  create_table "data_district_streets", :force => true do |t|
    t.integer  "district_id"
    t.string   "internal_key"
    t.string   "name"
    t.integer  "housenumber"
    t.string   "housenumber_additional"
    t.string   "postcode"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
  end

  create_table "data_mediahandbook_branches", :force => true do |t|
    t.integer  "parent_id"
    t.string   "internal_type"
    t.string   "internal_key"
    t.string   "name"
    t.text     "description",   :limit => 255
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  create_table "data_mediahandbook_companies", :force => true do |t|
    t.integer  "old_id"
    t.integer  "sub_market_id"
    t.integer  "main_branch_id"
    t.string   "name"
    t.string   "street"
    t.integer  "housenumber"
    t.string   "housenumber_additional"
    t.string   "postcode"
    t.string   "city"
    t.string   "phone_primary"
    t.string   "phone_secondary"
    t.string   "fax_primary"
    t.string   "fax_secondary"
    t.string   "mobile_primary"
    t.string   "mobile_secondary"
    t.string   "email_primary"
    t.string   "email_secondary"
    t.string   "url_primary"
    t.string   "url_secondary"
    t.text     "main_activity"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
    t.text     "products"
    t.text     "resources"
    t.text     "past_customers"
    t.integer  "mkw_branch_id"
  end

  create_table "data_mediahandbook_people", :force => true do |t|
    t.integer  "company_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "title"
    t.string   "position"
    t.string   "occupation"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "mediahandbook_branches_companies", :id => false, :force => true do |t|
    t.integer "company_id"
    t.integer "branch_id"
  end

  create_table "permissions", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "access"
    t.string   "table"
    t.string   "column"
    t.string   "source"
  end

  create_table "permissions_users", :id => false, :force => true do |t|
    t.integer "permission_id"
    t.integer "user_id"
  end

  create_table "request_logs", :force => true do |t|
    t.string   "api_key"
    t.string   "ip"
    t.string   "source"
    t.string   "model"
    t.string   "request_path"
    t.string   "query_string"
    t.string   "method"
    t.datetime "created_at"
    t.string   "user_agent"
  end

  create_table "temp_syncs", :force => true do |t|
    t.text     "json"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                              :null => false
    t.string   "crypted_password",                   :null => false
    t.string   "password_salt",                      :null => false
    t.string   "persistence_token",                  :null => false
    t.string   "single_access_token",                :null => false
    t.string   "perishable_token",                   :null => false
    t.integer  "login_count",         :default => 0, :null => false
    t.integer  "failed_login_count",  :default => 0, :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.boolean  "admin"
    t.boolean  "active"
    t.string   "name"
    t.string   "telefon"
  end

end
