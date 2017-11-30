# This file is autogenerated. Instead of editing this file, please use the
# migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.

ActiveRecord::Schema.define(:version => 2) do

  create_table "dailyweights", :force => true do |t|
    t.column "todays_weight", :decimal, :precision => 4, :scale => 1, :null => false
    t.column "review",        :text
    t.column "submit_date",   :date
  end

  create_table "loadmaps", :force => true do |t|
    t.column "current_weight", :decimal, :precision => 4, :scale => 1, :null => false
    t.column "target_weight",  :decimal, :precision => 4, :scale => 1, :null => false
    t.column "start_date",     :date,                                  :null => false
    t.column "target_date",    :date,                                  :null => false
    t.column "created_on",     :date
    t.column "updated_on",     :date
  end

end