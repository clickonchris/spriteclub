class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      #the limit=>8 should make facebook_id a bigint
      t.integer :facebook_id, :limit=>8, :null=>false
      t.string :session_key
      t.string :secret_key
      t.string :first_name, :limit=>100
      t.string :last_name, :limit=>100

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
