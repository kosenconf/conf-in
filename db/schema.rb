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

ActiveRecord::Schema.define(:version => 20110831040315) do

  create_table "entries", :force => true do |t|
    t.integer  "event_id"
    t.integer  "user_id"
    t.string   "select1"
    t.string   "select2"
    t.string   "select3"
    t.string   "select4"
    t.string   "select5"
    t.text     "free1"
    t.text     "free2"
    t.text     "free3"
    t.text     "free4"
    t.text     "free5"
    t.text     "comment"
    t.integer  "received"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", :force => true do |t|
    t.string   "name"
    t.datetime "date"
    t.text     "summary"
    t.string   "website"
    t.string   "place_name"
    t.string   "place_room"
    t.string   "place_address"
    t.string   "place_website"
    t.integer  "capacity"
    t.decimal  "expense"
    t.datetime "joinable_period_begin"
    t.datetime "joinable_period_end"
    t.string   "hosting_group"
    t.string   "hosting_email"
    t.integer  "main_event_id"
    t.integer  "owner_user_id"
    t.string   "select1"
    t.string   "select2"
    t.string   "select3"
    t.string   "select4"
    t.string   "select5"
    t.string   "select_content1"
    t.string   "select_content2"
    t.string   "select_content3"
    t.string   "select_content4"
    t.string   "select_content5"
    t.integer  "select_setting1"
    t.integer  "select_setting2"
    t.integer  "select_setting3"
    t.integer  "select_setting4"
    t.integer  "select_setting5"
    t.string   "free1"
    t.string   "free2"
    t.string   "free3"
    t.string   "free4"
    t.string   "free5"
    t.integer  "free_setting1"
    t.integer  "free_setting2"
    t.integer  "free_setting3"
    t.integer  "free_setting4"
    t.integer  "free_setting5"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "admin_token"
  end

  add_index "events", ["admin_token"], :name => "index_events_on_admin_token", :unique => true

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.text     "memo"
    t.string   "website"
    t.string   "qr_secret"
    t.string   "job"
    t.string   "office"
    t.string   "domicile"
    t.integer  "tw_uid"
    t.string   "tw_name"
    t.string   "tw_token"
    t.string   "tw_secret"
    t.string   "fb_token"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
