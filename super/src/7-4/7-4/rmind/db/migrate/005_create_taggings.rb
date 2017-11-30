class CreateTaggings < ActiveRecord::Migration
  def self.up
    create_table :taggings do |t|
      t.column "user_id", :integer, :null=>false
      t.column "task_id", :integer, :null=>false
      t.column "tag_id", :integer, :null=>false
      t.column "type", :string, :limit => 30, :null => false
    end

    add_index :taggings, [:user_id, :tag_id]
    add_index :taggings, :task_id
  end

  def self.down
    remove_index :taggings, [:user_id, :tag_id]
    remove_index :taggings, :task_id
    drop_table :taggings
  end
end
