class CreateTags < ActiveRecord::Migration
  def self.up
    create_table :tags do |t|
      t.column "user_id", :integer, :null => false
      t.column "name", :string, :limit => 100, :null => false
      t.column "type", :string, :limit => 30, :null => false
    end

    add_index :tags, :user_id
  end

  def self.down
    remove_index :tags, :user_id
    drop_table :tags
  end
end
