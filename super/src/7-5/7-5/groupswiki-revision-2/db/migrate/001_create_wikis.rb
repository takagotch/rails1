class CreateWikis < ActiveRecord::Migration
  def self.up
    create_table :wikis do |t|
      t.column :name, :string
      t.column :email, :string
    end
  end

  def self.down
    drop_table :wikis
  end
end
