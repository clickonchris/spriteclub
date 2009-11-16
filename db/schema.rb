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

ActiveRecord::Schema.define(:version => 20091110133748) do

  create_table "challenges", :force => true do |t|
    t.integer  "initiated_by_user_id"
    t.integer  "sent_to_user_id"
    t.string   "status"
    t.datetime "expire_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contestants", :force => true do |t|
    t.integer  "contest_id",                           :null => false
    t.string   "first_name",       :limit => 100
    t.string   "last_name",        :limit => 100
    t.string   "middle_name",      :limit => 50
    t.binary   "image_file",       :limit => 16777215
    t.string   "photo_url"
    t.integer  "total_points"
    t.integer  "experience_level"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "owner_user_id"
  end

  create_table "contests", :force => true do |t|
    t.integer  "challenge_id"
    t.string   "name"
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "winner_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.integer  "facebook_id",                :null => false
    t.string   "session_key"
    t.string   "first_name",  :limit => 100
    t.string   "last_name",   :limit => 100
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "votes", :force => true do |t|
    t.integer  "user_id"
    t.integer  "contestant_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
