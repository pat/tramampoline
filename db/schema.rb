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

ActiveRecord::Schema.define(:version => 20100418164529) do

  create_table "attendees", :force => true do |t|
    t.string   "name",                          :null => false
    t.string   "email",                         :null => false
    t.string   "phone",         :default => ""
    t.string   "invite_email",  :default => ""
    t.string   "invite_code",   :default => ""
    t.string   "referral_code", :default => ""
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subscribers", :force => true do |t|
    t.string   "name",       :default => ""
    t.string   "email",                      :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
