class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string :city
      t.string :venue
      t.integer :max_attendees
      t.date :happens_on
      t.datetime :release_at
      t.datetime :excess_at

      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
