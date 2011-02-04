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

ActiveRecord::Schema.define(:version => 20110202105400) do

  create_table "companies_branches", :id => false, :force => true do |t|
    t.integer "company_id"
    t.integer "branch_id"
  end

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

  create_table "permissions", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "access"
    t.string   "table"
    t.string   "column"
  end

  create_table "permissions_users", :id => false, :force => true do |t|
    t.integer  "permission_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "request_logs", :force => true do |t|
    t.string "api_key"
    t.string "ip"
    t.string "dataset"
    t.string "model"
    t.string "request_path"
    t.string "query_string"
    t.string "method"
    t.string "created_at"
  end

  create_table "temp_syncs", :force => true do |t|
    t.text     "json"
    t.datetime "created_at"
    t.datetime "updated_at"
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
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin"
    t.boolean  "active"
    t.string   "name"
    t.string   "telefon"
  end

end
