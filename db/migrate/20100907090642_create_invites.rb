class CreateInvites < ActiveRecord::Migration
  def self.up
    create_table :invites do |t|
      t.string :code,        :null => false
      t.string :description, :null => false, :default => ''
      t.integer :event_id,   :null => false
      t.integer :amount,     :null => false, :default => 1
      t.timestamps
    end
    
    add_index :invites, :code
    add_index :invites, :event_id
  end

  def self.down
    drop_table :invites
  end
end
