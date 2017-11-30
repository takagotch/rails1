class CreatePageAutosaves < ActiveRecord::Migration
  def self.up
    create_table :page_autosaves do |t|
      t.column :page_id, :integer
      t.column :created_at, :timestamp
      t.column :content, :string
      t.column :user_id, :integer
    end
  end

  def self.down
    drop_table :page_autosaves
  end
end
