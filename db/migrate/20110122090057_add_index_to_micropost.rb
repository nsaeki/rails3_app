class AddIndexToMicropost < ActiveRecord::Migration
  def self.up
    add_index :microposts, :user_id
  end

  def self.down
    remove_index :microposts, :user_id
  end
end
