class ResizeUsersSessionKey < ActiveRecord::Migration
  def self.up
    change_column(:users, :session_key, :string, :limit=>'128')
  end

  def self.down
  end
end
