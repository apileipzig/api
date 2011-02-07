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

ActiveRecord::Schema.define(:version => 20110207113313) do

  create_table "calendar_hosts", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone"
    t.string   "mobile_primary"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "data_calendar_events", :force => true do |t|
    t.integer  "category_id"
    t.integer  "host_id_id"
    t.integer  "venue_id_id"
    t.date     "date_from"
    t.time     "time_from"
    t.date     "date_to"
    t.time     "time_to"
    t.string   "name"
    t.text     "description"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
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
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "data_mediahandbook_branches", :force => true do |t|
    t.integer  "parent_id"
    t.string   "internal_type"
    t.string   "internal_key"
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
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
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mediahandbook_branches_companies", :id => false, :force => true do |t|
    t.integer "company_id"
    t.integer "branch_id"
  end

  create_table "mediahandbook_people", :force => true do |t|
    t.integer  "company_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "title"
    t.string   "position"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
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
  end

  create_table "temp_syncs", :force => true do |t|
    t.text     "json"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
