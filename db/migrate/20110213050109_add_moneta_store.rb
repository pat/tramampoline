class AddMonetaStore < ActiveRecord::Migration
  def self.up
    create_table :moneta_store, :id => false do |t|
      t.string :key, :null => false
      t.text   :value
    end

    execute "alter table moneta_store add primary key (key)"
  end
  
  def self.down
    drop_table :moneta_store
  end
end
