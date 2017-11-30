class Loadmap < ActiveRecord::Base
  validates_numericality_of :current_weight ,:allow_nil=>false,:message=>"現在の体重には数値を入力してください。"
  validates_numericality_of :target_weight  ,:allow_nil=>false,:message=>"目標の体重には数値を入力してください。"
  validates_each :target_date do |record,attribute,value|
    record.errors.add(:target_date,"いつまでに？には今日以降の日付を入力してください。") if value < Date.today
  end
end
