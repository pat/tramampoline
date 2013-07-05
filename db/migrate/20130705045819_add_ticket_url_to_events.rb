class AddTicketUrlToEvents < ActiveRecord::Migration
  def change
    add_column :events, :ticket_url, :string
  end
end
