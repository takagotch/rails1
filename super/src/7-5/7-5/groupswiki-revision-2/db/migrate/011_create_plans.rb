class CreatePlans < ActiveRecord::Migration
  def self.up
    create_table :plans do |t|
      t.column :name, :string
      t.column :monthly_fee, :integer
    end
    
    add_column :wikis, :plan_id, :integer
  end

  def self.down
    drop_table :plans
    remove_column :wikis, :plan_id
  end
end
