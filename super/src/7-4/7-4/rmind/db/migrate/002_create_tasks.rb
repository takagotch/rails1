class CreateTasks < ActiveRecord::Migration
  def self.up
    create_table :tasks do |t|
      t.column "user_id", :integer, :null => false
      t.column "project_id", :integer, :null => false
      t.column "text", :string, :limit => 255, :null => false
      t.column "url", :string, :limit => 255
      t.column "status", :integer, :null => false, :default=>0
      t.column "created_at", :datetime
      t.column "updated_at", :datetime
      t.column "done_at", :datetime
      t.column "trashed_at", :datetime
    end

    add_index :tasks, :user_id
    add_index :tasks, [:user_id, :project_id]
  end

  def self.down
    remove_index :tasks, :user_id
    remove_index :tasks, [:user_id, :project_id]
    drop_table :tasks
  end
end
