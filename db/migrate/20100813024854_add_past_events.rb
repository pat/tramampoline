class AddPastEvents < ActiveRecord::Migration
  def self.up
    Event.create! :city => "Melbourne", :venue => "Donkey Wheel House", :happens_on => Date.new(2009, 3, 28)
    Event.create! :city => "Melbourne", :venue => "Donkey Wheel House", :happens_on => Date.new(2009, 10, 24)
    Event.create! :city => "Melbourne", :venue => "Donkey Wheel House", :happens_on => Date.new(2010, 5, 2)
  end

  def self.down
  end
end
