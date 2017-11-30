class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.column :name, :string
      t.column :content, :string
      t.column :wiki_id, :integer
    end
  end

  def self.down
    drop_table :pages
  end
end
