class AddLoginToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :login_name, :string
    add_index :users, :login_name, :unique => true
  end

  def self.down
    remove_column :users, :login_name
  end
end
