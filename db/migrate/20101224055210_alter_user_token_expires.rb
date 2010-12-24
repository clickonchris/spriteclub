class AlterUserTokenExpires < ActiveRecord::Migration
  def self.up
    remove_column :users, :expires
    add_column :users, :access_token_expires, :timestamp
  end

  def self.down
    remove_column :users, :access_token_expires
  end
end
