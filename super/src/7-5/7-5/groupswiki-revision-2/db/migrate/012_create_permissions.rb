class CreatePermissions < ActiveRecord::Migration
  def self.up
    create_table :permissions do |t|
      t.column :user_id, :integer
      t.column :wiki_id, :integer
      t.column :created_at, :timestamp
    end
  end

  def self.down
    drop_table :permissions
  end
end
