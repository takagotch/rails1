class AddUserIdToPages < ActiveRecord::Migration
  def self.up
    add_column :page_versions, :path, :string

    add_column :pages, :user_id, :integer
    add_column :page_versions, :user_id, :integer
  end

  def self.down
  end
end
