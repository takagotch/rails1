class CreateConditions < ActiveRecord::Migration
  def self.up
    create_table :conditions do |t|
      t.column :user_id, :integer    # userテーブルの利用者の参照id
      t.column :name, :string        # その日の気持ち
      t.column :date, :date          # 登録したい日付
   end
   add_index :conditions, :user_id 
  end

  def self.down
    drop_table :conditions
  end
end
