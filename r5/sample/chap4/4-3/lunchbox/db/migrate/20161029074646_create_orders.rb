class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
      t.date :orderdate
      t.references :member, foreign_key: true
      t.references :box, foreign_key: true

      t.timestamps
    end
  end
end
