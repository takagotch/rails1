# This file is autogenerated. Instead of editing this file, please use the
# migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.

ActiveRecord::Schema.define(:version => 1) do

  create_table "tasks", :force => true do |t|
    t.column "content",    :text
    t.column "status",     :string
    t.column "priority",   :integer
    t.column "owner",      :string
    t.column "created_on", :datetime
    t.column "updated_on", :datetime
  end

end
