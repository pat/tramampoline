class AddConfirmedToAttendees < ActiveRecord::Migration
  def self.up
    add_column :attendees, :confirmed, :boolean, :default => false

    execute 'UPDATE attendees SET confirmed = true'

    add_index :attendees, :confirmed
  end

  def self.down
    remove_index  :attendees, :confirmed
    remove_column :attendees, :confirmed
  end
end
