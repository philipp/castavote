# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20080824212802) do

  create_table "answers", :force => true do |t|
    t.string   "value"
    t.integer  "question_id", :limit => 11
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "answers", ["question_id"], :name => "index_answers_on_question_id"

  create_table "companies", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "joining_code"
  end

  add_index "companies", ["joining_code"], :name => "index_companies_on_joining_code"
  add_index "companies", ["name"], :name => "index_companies_on_name"

  create_table "events", :force => true do |t|
    t.string   "name"
    t.datetime "date"
    t.integer  "company_id", :limit => 11
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "events", ["company_id"], :name => "index_events_on_company_id"

  create_table "profiles", :force => true do |t|
    t.integer  "company_id", :limit => 11, :null => false
    t.integer  "user_id",    :limit => 11, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "profiles", ["company_id", "user_id"], :name => "index_profiles_on_company_id_and_user_id", :unique => true
  add_index "profiles", ["company_id"], :name => "index_profiles_on_company_id"
  add_index "profiles", ["user_id"], :name => "index_profiles_on_user_id"

  create_table "questions", :force => true do |t|
    t.string   "question"
    t.integer  "event_id",    :limit => 11
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "votes_count", :limit => 11, :default => 0
    t.boolean  "active",                    :default => false, :null => false
  end

  add_index "questions", ["event_id"], :name => "index_questions_on_event_id"

  create_table "users", :force => true do |t|
    t.string   "login",                     :limit => 40
    t.string   "name",                      :limit => 100, :default => ""
    t.string   "email",                     :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.integer  "preallowed_id",             :limit => 11
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

  create_table "votes", :force => true do |t|
    t.integer  "user_id",    :limit => 11
    t.integer  "answer_id",  :limit => 11
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["user_id"], :name => "index_votes_on_user_id"
  add_index "votes", ["answer_id"], :name => "index_votes_on_answer_id"

end
