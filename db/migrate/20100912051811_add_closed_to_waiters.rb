class AddClosedToWaiters < ActiveRecord::Migration
  def self.up
    add_column :waiters, :closed, :boolean, :default => false
    add_index  :waiters, :closed
  end
  
  def self.down
    remove_index  :waiters, :closed
    remove_column :waiters, :closed
  end
end
