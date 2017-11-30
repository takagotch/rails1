class RemoveIdFromPerms < ActiveRecord::Migration
  def self.up
    remove_column :permissions, :id
    remove_column :permissions, :created_at
  end

  def self.down
  end
end
