class CreatePrivateKeys < ActiveRecord::Migration
  def self.up
    create_table :private_keys do |t|
      t.column "user_id", :integer, :null=>false
      t.column "export_tag_id", :integer, :null=>false
      t.column "key", :string, :limit => 32, :null=>false
    end
    add_index :private_keys, [:user_id, :export_tag_id]
    add_index :private_keys, [:key]
  end

  def self.down
    remove_index :private_keys, [:key]
    remove_index :private_keys, [:user_id, :export_tag_id]
    drop_table :private_keys
  end
end
