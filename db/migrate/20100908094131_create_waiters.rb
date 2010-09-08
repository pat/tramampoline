class CreateWaiters < ActiveRecord::Migration
  def self.up
    create_table :waiters do |t|
      t.string :name
      t.string :email
      t.string :code
      t.integer :event_id

      t.timestamps
    end
  end

  def self.down
    drop_table :waiters
  end
end
