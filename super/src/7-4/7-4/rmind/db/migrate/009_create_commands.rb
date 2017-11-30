class CreateCommands < ActiveRecord::Migration
  def self.up
    create_table :commands do |t|
      t.column "user_id", :integer, :null => false
      t.column "task_id", :integer
      t.column "tag_id", :integer
      t.column "project_id", :integer
      t.column "type", :string, :limit => 30, :null => false
      t.column "done_at", :datetime
      t.column "params", :text
      t.column "data_for_undo", :text
    end

    add_index :commands, :user_id
  end

  def self.down
    remove_index :commands, :user_id
    drop_table :commands
  end
end
