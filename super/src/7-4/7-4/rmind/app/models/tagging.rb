class Tagging < ActiveRecord::Base
  belongs_to :user
  belongs_to :task
  belongs_to :tag

  def set_tagging_value(v)
  end

  def form_name
    nil
  end
end

class PlainTagging < Tagging
end

class MemoTagging < Tagging
  has_one :memo, :dependent => :destroy

  def set_tagging_value(v)
    v[tag.name][:memo] = self.memo.memo
  end

  def form_name
    'memo'
  end
end

class ScheduleTagging < Tagging
  has_one :schedule, :dependent => :destroy

  def set_tagging_value(v)
    schedule.user_attributes.each do |k|
      v[tag.name][k] = schedule.send(k)
    end
  end

  def form_name
    'schedule'
  end
end
