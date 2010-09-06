class AddCancelledAtToAttendees < ActiveRecord::Migration
  def self.up
    add_column :attendees, :cancelled_at, :datetime
  end

  def self.down
    remove_column :attendees, :cancelled_at
  end
end
