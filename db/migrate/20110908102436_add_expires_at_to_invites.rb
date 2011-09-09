class AddExpiresAtToInvites < ActiveRecord::Migration
  def self.up
    add_column :invites, :expires_at, :datetime
  end

  def self.down
    remove_column :invites, :expires_at
  end
end
