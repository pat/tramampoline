class AddMapLinksToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :address, :string
    add_column :events, :map_uri, :string, :limit => 512
    add_column :events, :embedded_map_uri, :string, :limit => 512
  end

  def self.down
    remove_column :events, :address
    remove_column :events, :map_uri
    remove_column :events, :embedded_map_uri
  end
end
