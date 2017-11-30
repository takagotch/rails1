class CreateConditions < ActiveRecord::Migration
  def self.up
    create_table :conditions do |t|
      t.column :user_id, :integer
      t.column :name, :string
      t.column :date, :date
   end
   add_index :conditions, :user_id 
  end

  def self.down
    drop_table :conditions
  end
end
