class CreateLoadmaps < ActiveRecord::Migration
  def self.up
    create_table(:loadmaps) do |table|
      #現在体重
      table.column  :current_weight , :decimal , :precision  => 4 , :scale => 1 , :null => false
      #目標体重
      table.column  :target_weight , :decimal , :precision  => 4 , :scale => 1 , :null => false
      #開始日
      table.column  :start_date , :date , :null => false
      #目標日
      table.column  :target_date , :date , :null => false
      #作成日
      table.column  :created_on , :date
      #更新日
      table.column  :updated_on , :date
    end
  end

  def self.down
    drop_table  :loadmaps
  end
end
