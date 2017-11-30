class CreateMemos < ActiveRecord::Migration
  def self.up
    create_table :memos do |t|
      t.column "user_id", :integer, :null=>false
      t.column "memo_tagging_id", :integer, :null=>false
      t.column "memo", :text
    end

    add_index :memos, [:user_id, :memo_tagging_id]
  end

  def self.down
    remove_index :memos, [:user_id, :memo_tagging_id]
    drop_table :memos
  end
end
