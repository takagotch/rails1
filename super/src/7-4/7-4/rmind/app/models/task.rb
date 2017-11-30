require 'tag'

class Task < ActiveRecord::Base
  self.record_timestamps = false
  include SwitchableTimestamp

  belongs_to :user
  belongs_to :project
  has_many :taggings, :dependent => :destroy

  after_save :save_tags

  attr_reader :tagging_value

  validates_presence_of :text

  def self.tasks_by_date(tasks, prop)
    tasks.inject([]) do |ret, task|
      d = task.send(prop)
      h = ret.last
      if h.nil? or h[:date].yday != d.yday or h[:date].year != d.year
        h = {
          :date => d.beginning_of_day,
          :tasks => []
        }
        ret << h
      end
      h[:tasks] << task
      ret
    end
  end

  module Status
    Inbox = 0
    Processed = 1
    NextAction = 2
    Waiting = 3
    Done = 4
    Trashed = 5
  end

  def initialize(*args)
    super(*args)
    @tag = nil
    #@tag_value = {}
    init_tagging_value
  end

  def inspect
    "Task #{attributes.inspect}"
  end

  def tags
    taggings.collect do |tagging|
      tagging.tag
    end.sort_by do |t|
      t.name
    end
  end

  def before_save
    unless self.user
      self.user = self.project.user
    end
    unless self.project
      self.project = self.user.root_project
    end
    set_status
  end

  def url=(url)
    url = URI.unescape(url) if url
    super(url)
  end

  def reload
    @tag = nil
    super
  end

  def done?
    not done_at.nil?
  end

  def record_done
    self.done_at = Time.now
    self
  end

  def trashed?
    not trashed_at.nil?
  end

  def trash
    self.trashed_at = Time.now
    self
  end

  def save_tags
    return unless @tag
    taggings.clear
    split_tag(tag).each do |t|
      tag = Tag.create_or_find_by_name(self.user, t)
      tag.tag(self)
    end
    status = self.status
    set_status
    save! if status != self.status
  end

  def tag
    unless @tag
      @tag = tags.collect { |t| t.name}.join(' ')
    end
    @tag
  end

  def tag=(tag_str)
    @tag = tag_str
  end

#   def load_tag_value
#     @tag_value = {}
#     taggings.each do |t|
#       t.tag.set_tag_value(@tag_value)
#     end
#   end

  def load_tagging_value
    init_tagging_value
    taggings.each do |t|
      t.set_tagging_value(@tagging_value)
    end
  end

  def init_tagging_value
    @tagging_value = Hash.new { |h, k| h[k] = Hash.new }
  end

  def tr_id
    "task_#{id}"
  end

  def to_yaml_obj
    load_tagging_value
    {
      :text => text,
      :url => url,
      :created_at => created_at,
      :updated_at => updated_at,
      :done_at => done_at,
      :trashed_at => trashed_at,
      :tag => tag,
      :tagging_value => tagging_value,
    }
  end

  def self.load_yaml_obj(prj, td)
    data = {
      :text => td[:text],
      :url => td[:url],
      :done_at => td[:done_at],
      :trashed_at => td[:trashed_at],
      :use_record_timestamps => false
    }
    task = prj.tasks.create!(data)
    task.tagging_value.merge!(td[:tagging_value])
    task.tag = td[:tag]
    task.created_at = td[:created_at]
    task.updated_at = td[:updated_at]
    task.save!

    task
  end


  private

  def split_tag(tag_str)
    tag_str.split(/[ 　]/) # space or unicode space
  end

  def set_status
    self.status =
      if trashed?
        Status::Trashed
      elsif done_at?
        Status::Done
      elsif has_context_tag?
        Status::NextAction
      elsif has_waiting_tag?
        Status::Waiting
      elsif project_id != user.root_project.id
        Status::Processed
      else
        Status::Inbox
      end
  end

  def has_context_tag?
    tags.any? do |t|
      t.kind_of?(ContextTag)
    end
  end

  def has_waiting_tag?
    tags.any? do |t|
      t.kind_of?(DelegationTag) or t.kind_of?(ScheduleTag)
    end
  end
end

