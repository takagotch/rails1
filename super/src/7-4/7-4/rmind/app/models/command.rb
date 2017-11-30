class Command < ActiveRecord::Base
  belongs_to :user
  belongs_to :task
  belongs_to :tag
  belongs_to :tagging
  belongs_to :project
  serialize :params
  serialize :data_for_undo

  def do
    self.done_at = Time.now
    save!
    self
  end

  def undo
    raise 'not implemented'
  end

  def description
    self.class.to_s
  end

  def command_message
    "#{description} executed "
  end
end

class CreateTaskCommand < Command
  def self.create(user, text, url=nil, memo=nil)
    super(:user=>user, :params=>{ :text=>text , :url=>url, :memo=>memo})
  end

  def do
    self.task = user.root_project.tasks.create!(:text => self.params[:text], :url=>self.params[:url])
    unless self.params[:memo].blank?
      self.task.tag = 'memo'
      self.task.tagging_value['memo'][:memo] = self.params[:memo]
      self.task.save!
    end
    super
  end

  def undo
    task.destroy
    self
  end

  def description
    text = " (#{task.text})" if task and task.text
    "creation of task#{text} "
  end
end

class UpdateTaskCommand < Command
  def self.create(user, task_id, attributes, tagging_value=nil)
    super(:user=>user, :task_id=>task_id, :params =>attributes.merge(:tagging_value=>tagging_value))
  end

  def do
    tagging_value = params.delete(:tagging_value)
    a = params
    task.load_tagging_value
    self.params = task.attributes.merge(:tagging_value => task.tagging_value, :tag=>task.tag)
    task.tagging_value.merge!(tagging_value) if tagging_value
    task.use_record_timestamps = true
    task.attributes = a
    task.save!
    super
  end

  def undo
    a = params
    tag = a.delete(:tag)
    tagging_value = a.delete(:tagging_value)
    if tagging_value
      task.load_tagging_value
      task.tagging_value.merge!(tagging_value)
    end
    task.tag = tag
    task.update_attributes!(a)
    self
  end
end

class MoveTaskCommand < UpdateTaskCommand
  def self.create(user, task_id, project_id)
    super(user, task_id, :project_id=>project_id)
  end
end


class CreateProjectCommand < Command
  def self.create(user, parent_id, name, interval=nil)
    super(:user=>user, :params=>{ :parent_id=>parent_id, :name=>name, :review_interval=>interval })
  end

  def do
    a = self.params
    parent = Project.find(a[:parent_id])
    interval = a[:review_interval] || parent.review_interval
    self.project = Project.create(:parent=>parent, :name=>a[:name], :review_interval=>interval)
    super
  end

  def undo
    project.destroy
    self
  end
end

class TaskStatusCommand < Command
  def self.create(x, status, *args)
    case x
    when Task
      super(:user=>x.user, :task=>x, :params => { :status=>status} )
    else
      raise "unknown param for TaskStatusCommand #{x.inspect}"
    end
  end

  def do
    case params[:status]
    when :done
      task.done_at = Time.now
    when :undone
      params[:done_at] = task.done_at
      task.done_at = nil
    when :trash
      task.trashed_at = Time.now
    when :untrash
      params[:trashed_at] = task.trashed_at
      task.trashed_at = nil
    else
      raise 'cant happen'
    end
    task.save!
    super
  end

  def undo
    case params[:status]
    when :done
      task.done_at = nil
    when :undone
      task.done_at = params[:done_at]
    when :trash
      task.trashed_at = nil
    when :untrash
      task.trashed_at = params[:trashed_at]
    else
      raise 'cant happen'
    end
    task.save!
    self
  end
end

class ProjectReviewCommand < Command
  def self.create(x)
    case x
    when Project
      super(:user=>x.user, :project=>x)
    else
      raise "unknown param for ProjectReviewCommand "
    end
  end

  def do
    project.reviewed_at = Time.now
    project.save!
    super
  end
end

class UpdateProjectCommand < Command
  def self.create(x)
    case x
    when Project
      super(:user=>x.user, :project=>x)
    else
      raise "unknown param for #{self.class}"
    end
  end

  def do
    project.save!
    super
  end
end

class TaskToProjectCommand < Command
  def self.create(task)
    super(:user=>task.user, :task_id=>task.id)
  end

  def do
    self.params = { :old_project_id => task.project_id }
    create_project
    task.project = self.project
    task.save!
    super
  end

  def create_project
    parent = task.project
    interval = parent.review_interval
    self.project = Project.create!(:parent=>parent, :name=>task.text, :review_interval=>interval)
  end

  def undo
    self.project.destroy
    task.project_id = params[:old_project_id]
    task.save!
    self
  end
end
