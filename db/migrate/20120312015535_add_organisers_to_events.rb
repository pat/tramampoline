class AddOrganisersToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :organisers, :string
    add_column :events, :signature,  :string,
      :default => 'Peace, love, and sticky rice'
  end

  def self.down
    remove_column :events, :organisers
    remove_column :events, :signature
  end
end
