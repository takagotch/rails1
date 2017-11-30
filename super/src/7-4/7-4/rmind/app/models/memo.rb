class Memo < ActiveRecord::Base
  belongs_to :user
  belongs_to :memo_tagging
end
