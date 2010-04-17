class CreateAttendees < ActiveRecord::Migration
  def self.up
    create_table :attendees do |t|
      t.string :name,          :null => false
      t.string :email,         :null => false
      t.string :phone,         :default => ''
      t.string :invite_email,  :default => ''
      t.string :invite_code,   :default => ''
      t.string :referral_code, :default => ''

      t.timestamps
    end
  end

  def self.down
    drop_table :attendees
  end
end
