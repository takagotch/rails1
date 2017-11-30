class AddVersioning < ActiveRecord::Migration
  def self.up
    Page.create_versioned_table
  end

  def self.down
  end
end
