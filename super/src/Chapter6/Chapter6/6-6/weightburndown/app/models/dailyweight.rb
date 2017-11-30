class Dailyweight < ActiveRecord::Base
  validates_numericality_of :todays_weight ,:allow_nil=>false,:message=>"体重には数値を入力してください。"
end
