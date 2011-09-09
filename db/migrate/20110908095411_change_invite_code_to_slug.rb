class ChangeInviteCodeToSlug < ActiveRecord::Migration
  def self.up
    rename_column :attendees, :invite_code, :slug
  end

  def self.down
    rename_column :attendees, :slug, :invite_code
  end
end
