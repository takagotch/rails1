class CreateProjects < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
      t.column "user_id", :integer, :null => false
      t.column "parent_project_id", :integer
      t.column "name", :string, :null => false
      t.column "goal", :string
      t.column "review_interval", :integer, :default => 0, :null => false
      t.column "created_at", :datetime
      t.column "updated_at", :datetime
      t.column "reviewed_at", :datetime
      t.column "next_review", :datetime
      t.column "locked", :boolean
    end

    add_index :projects, :user_id
    add_index :projects, [:user_id, :parent_project_id]
  end

  def self.down
    remove_index :projects, :user_id
    remove_index :projects, [:user_id, :parent_project_id]
    drop_table :projects
  end
end
