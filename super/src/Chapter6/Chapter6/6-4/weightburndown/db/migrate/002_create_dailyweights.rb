class CreateDailyweights < ActiveRecord::Migration
  def self.up
    create_table(:dailyweights) do |table|
      #今日の体重
      table.column  :todays_weight , :decimal , :precision  => 4 , :scale => 1 , :null => false
      #ひとこと
      table.column  :review , :text
      #記録日
      table.column  :submit_date , :date
    end
  end

  def self.down
    drop_table  :dailyweights
  end
end
