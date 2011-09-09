class AddParentToInvites < ActiveRecord::Migration
  def self.up
    add_column :invites, :parent_type, :string
    add_column :invites, :parent_id,   :integer

    add_index  :invites, :parent_type
    add_index  :invites, :parent_id
  end

  def self.down
    remove_column :invites, :parent_type
    remove_column :invites, :parent_id
  end
end
