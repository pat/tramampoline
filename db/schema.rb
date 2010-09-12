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

ActiveRecord::Schema.define(:version => 20100912051811) do

  create_table "attendees", :force => true do |t|
    t.string   "name",                          :null => false
    t.string   "email",                         :null => false
    t.string   "phone",         :default => ""
    t.string   "invite_email",  :default => ""
    t.string   "invite_code",   :default => ""
    t.string   "referral_code", :default => ""
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "event_id",      :default => 3,  :null => false
    t.datetime "cancelled_at"
  end

  create_table "events", :force => true do |t|
    t.string   "city"
    t.string   "venue"
    t.integer  "max_attendees"
    t.date     "happens_on"
    t.datetime "release_at"
    t.datetime "excess_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "address"
    t.string   "map_uri",          :limit => 512
    t.string   "embedded_map_uri", :limit => 512
  end

  create_table "invites", :force => true do |t|
    t.string   "code",                        :null => false
    t.string   "description", :default => "", :null => false
    t.integer  "event_id",                    :null => false
    t.integer  "amount",      :default => 1,  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "invites", ["code"], :name => "index_invites_on_code"
  add_index "invites", ["event_id"], :name => "index_invites_on_event_id"

  create_table "subscribers", :force => true do |t|
    t.string   "name",       :default => ""
    t.string   "email",                      :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "waiters", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "code"
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "attendee_id"
    t.datetime "invited_at"
    t.boolean  "closed",      :default => false
  end

  add_index "waiters", ["closed"], :name => "index_waiters_on_closed"

end
