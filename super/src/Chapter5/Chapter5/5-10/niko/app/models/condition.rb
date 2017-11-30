class Condition < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :user_id, :name, :date

  validates_inclusion_of :name,
                         :in=>%w( good bad normal ),
                         :message => "は good, bad, normal のいずれかでなければなりません。"
end
