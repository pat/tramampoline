class AddAttendeeAndInvitedAtToWaiters < ActiveRecord::Migration
  def self.up
    add_column :waiters, :attendee_id, :integer
    add_column :waiters, :invited_at, :datetime
  end
  
  def self.down
    remove_column :waiters, :invited_at
    remove_column :waiters, :attendee_id
  end
end
