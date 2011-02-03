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

ActiveRecord::Schema.define(:version => 20110128124107) do

  create_table "data_branches", :force => true do |t|
    t.integer  "parent_id"
    t.integer  "cluster_id"
    t.string   "internal_key"
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "data_companies", :force => true do |t|
    t.integer  "branch_id"
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

  create_table "people", :force => true do |t|
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
    t.string   "dataset"
    t.string   "model"
    t.string   "request_path"
    t.string   "query_string"
    t.string   "method"
    t.datetime "created_at",   :default => '2011-02-03 02:31:00'
  end

  create_table "temp_syncs", :force => true do |t|
    t.text     "json"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
