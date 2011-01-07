class ResizeUsersAccessToken < ActiveRecord::Migration
  def self.up
    change_column(:users, :access_token, :string, :limit=>'128')
  end

  def self.down
  end
end
