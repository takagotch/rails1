class AddUserIdToWikis < ActiveRecord::Migration
  def self.up
    add_column :wikis, :user_id, :integer
  end

  def self.down
    remove_column :wikis, :user_id
  end
end
