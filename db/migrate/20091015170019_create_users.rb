class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.integer :facebook_id, :limit=>20, :null=>false
      t.string :session_key
      t.string :first_name, :limit=>100
      t.string :last_name, :limit=>100

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
