class CreateIpNotifications < ActiveRecord::Migration
  def self.up
    create_table :ip_notifications do |t|
      t.string   :business
      t.string   :receiver_email
      t.string   :transaction_type
      t.string   :transaction_id
      t.integer  :attendee_id
      t.decimal  :amount, :precision => 6, :scale => 2
      t.datetime :payment_date
      t.string   :verification_signature
      t.string   :query_string, :limit => 2048
      t.string   :status
      t.timestamps
    end

    add_index :ip_notifications, :business
    add_index :ip_notifications, :attendee_id
    add_index :ip_notifications, :status
    add_index :ip_notifications, :transaction_id
    add_index :ip_notifications, :transaction_type
  end

  def self.down
    drop_table :ip_notifications
  end
end
