class SetEventForExistingAttendees < ActiveRecord::Migration
  def self.up
    Attendee.update_all("event_id = #{Event.past.last.id}")
  end
  
  def self.down
  end
end
