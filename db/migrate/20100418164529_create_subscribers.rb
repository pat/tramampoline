class CreateSubscribers < ActiveRecord::Migration
  def self.up
    create_table :subscribers do |t|
      t.string :name,  :default => ''
      t.string :email, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :subscribers
  end
end
