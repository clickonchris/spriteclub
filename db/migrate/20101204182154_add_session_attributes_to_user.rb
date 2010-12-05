class AddSessionAttributesToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :access_token, :string, :limit=>100
    add_column :users, :expires, :timestamp
  end

  def self.down
    remove_column :users, :access_token
    remove_column :users, :expires
  end
end
