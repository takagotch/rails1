class Tag < ActiveRecord::Base
  belongs_to :user
  has_many :taggings
  has_many :tasks

  def self.create_or_find_by_name(user, name)
    user.with_myscope do
      self.find_by_name(name) or
        ContextTag.create(:name=>name, :user_id=>user.id) or
        ScheduleTag.create(:name=>name, :user_id=>user.id) or
        DelegationTag.create(:name=>name, :user_id=>user.id) or
        MemoTag.create(:name=>name, :user_id=>user.id) or
        PlainTag.create(:name=>name, :user_id=>user.id)
    end
  end

  def tasks
    taggings.collect do |tagging|
      tagging.task
    end
  end

  def tag(task)
    create_tagging(task)
  ensure
    task.reload
  end

  def create_tagging(task)
    PlainTagging.create(:user=>task.user, :tag=>self, :task=>task)
  end

  def set_tag_value(hash)
  end

  def to_yaml_obj
    h = {
      :class => self.class.name,
      :name => self.name
    }
    set_tag_value(h)
    h
  end

  def inspect
    { :id => self.id }.merge(to_yaml_obj).inspect
  end

  def <=>(other)
    self.name <=> other.name
  end

  def self.load_yaml_obj(user, data)
    cls = Object.const_get(data[:class].intern)
    ret = cls.create(:user=>user, :name=>data[:name])
    ret
  end
end

class PlainTag < Tag
end

class MemoTag < Tag
  def self.create(arg)
    super(arg) if arg[:name] == 'memo'
  end

  def create_tagging(task)
    t = MemoTagging.create(:user_id=>self.user.id, :tag=>self, :task=>task)
    memo = task.tagging_value['memo'] ? task.tagging_value['memo'][:memo] : nil
    Memo.create(:user_id=>self.user.id, :memo_tagging=>t, :memo=>memo)
    t
  end
end

class ContextTag < Tag
  def self.create(arg)
    super(arg) if arg[:name] =~ /^@.*/
  end
end

class DelegationTag < Tag
  has_one :address, :dependent => :destroy
  def self.create(args)
    super(args) if args[:name] =~ /^id:.*/
  end

  def create_address(hash)
    h = {
      :user => self.user,
      :delegation_tag => self,
    }
    h.merge!(hash)
    Address.create(h)
  end

  def set_tag_value(hash)
    return unless a = address
    hash[:address] ||= {}
    Address.user_attributes.each do |k|
      hash[:address][k] = a.send(k)
    end
  end
end

class ScheduleTag < Tag
  def self.create(arg)
    super(arg) if arg[:name] =~ /(\d\d\d\d|\d\d)\d\d\d\d/
  end

  def create_tagging(task)
    t = ScheduleTagging.create(:user_id=>self.user.id, :tag=>self, :task=>task)
    raise "can't happen illegal name" unless name =~ /(\d\d\d\d|\d\d)(\d\d)(\d\d)/
    year = $1.to_i
    year += 2000 if year < 100
    dt = Date.new(year, $2.to_i, $3.to_i)
    sch = (task.tagging_value[name] || {}).merge({
                 :user_id=>self.user.id,
                 :schedule_tagging=>t,
                 :date=>dt,
               })
    parse_time(sch, :from)
    parse_time(sch, :to)
    Schedule.create(sch)
    t
  end

  private
  def parse_time(h, k)
    case h[k]
    when Time

    when /(\d?\d):(\d?\d)/
      h[k] = h[:date].to_time + $1.to_i.hours + $2.to_i.minutes
    else
      h[k] = nil
    end
  end
end
