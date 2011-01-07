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

ActiveRecord::Schema.define(:version => 20101231173556) do

  create_table "contestants", :force => true do |t|
    t.string   "name",               :limit => 200
    t.integer  "total_points"
    t.integer  "experience_level"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "owner_user_id"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.string   "gender",             :limit => 1
  end

  create_table "contestants_contests", :id => false, :force => true do |t|
    t.integer "contest_id"
    t.integer "contestant_id"
  end

  create_table "contests", :force => true do |t|
    t.string   "name"
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "winner_contestant_id"
    t.integer  "initiated_by_user_id"
    t.integer  "sent_to_user_id"
    t.string   "status"
    t.datetime "expire_date"
    t.datetime "finish_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_a_tie"
    t.integer  "length"
  end

  create_table "rewards", :force => true do |t|
    t.string   "description",   :limit => 512
    t.integer  "points"
    t.integer  "user_id"
    t.integer  "contestant_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.integer  "facebook_id",          :limit => 8,   :null => false
    t.string   "session_key"
    t.string   "secret_key"
    t.string   "first_name",           :limit => 100
    t.string   "last_name",            :limit => 100
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "access_token",         :limit => 100
    t.datetime "access_token_expires"
  end

  create_table "votes", :force => true do |t|
    t.integer  "user_id"
    t.integer  "contestant_id"
    t.integer  "contest_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
