class AddAnyoneWriteToPages < ActiveRecord::Migration
  def self.up
    add_column :wikis, :anyone_write, :boolean, :default => true
    add_column :wikis, :anyone_read, :boolean, :default => true
  end

  def self.down
    remove_column :wikis, :anyone_write
    remove_column :wikis, :anyone_read
  end
end
