class AddEventToAttendees < ActiveRecord::Migration
  def self.up
    add_column :attendees, :event_id, :integer, :null => false, :default => Event.past.last.id
    add_index :attendees, :event_id
  end

  def self.down
    remove_index :attendees, :event_id
    remove_column :attendees, :event_id
  end
end
