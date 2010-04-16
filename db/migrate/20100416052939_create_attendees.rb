class CreateAttendees < ActiveRecord::Migration
  def self.up
    create_table :attendees do |t|
      t.string :name
      t.string :email
      t.string :phone
      t.string :invite_email
      t.string :invite_code
      t.string :referral_code

      t.timestamps
    end
  end

  def self.down
    drop_table :attendees
  end
end
