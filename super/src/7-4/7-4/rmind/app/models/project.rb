class Project < ActiveRecord::Base
  self.record_timestamps = false
  include SwitchableTimestamp

  belongs_to :user
  has_many :sub_projects, :class_name=> 'Project', :foreign_key => 'parent_project_id'
  belongs_to :parent, :class_name => 'Project', :foreign_key => 'parent_project_id'
  has_many :tasks

  validates_uniqueness_of :name, :scope => :user_id

  def before_create
    #self.reviewed_at = self.created_at
  end

  def before_save
    if parent
      self.user = parent.user
    end

    self.next_review =
      if reviewed_at
        reviewed_at + review_interval.to_i.days
      else
        nil
      end
  end

  def after_save
    if parent == nil and self.user.root_project != self
      self.user.root_project.sub_projects << self
    end
  end

  def before_destroy
    self.reload
    raise LockedError if locked
  end

  def validate
    errors.add("user", "should be set user or parent") unless parent or user
  end

  def tree(level=0)
    sub_projects.inject([[ level, self]]) do |ret, prj|
      ret + prj.tree(level+1)
    end
  end

  def record_review
    self.use_record_timestamps = false
    self.reviewed_at = Time.now
    save!
  end

  def tasks_done(since=nil)
    q = my_task_query
    q.status_eq(Task::Status::Done)
    q.done_at_gte(since) if since
    q.find(:all, :order=>'done_at')
  end

  def next_actions
    q = my_task_query
    q.status_eq(Task::Status::NextAction)
    q.find(:all, :order=>'updated_at')
  end

  def processing_tasks
    q = my_task_query
    q.status_ne(Task::Status::Done)
    q.status_ne(Task::Status::NextAction)
    q.find(:all, :order=>'updated_at')
  end


  def to_yaml_obj
    {
      :name => name,
      :review_interval => review_interval,
      :parent => (parent ? parent.name : nil) ,
      :created_at => created_at,
      :updated_at => updated_at,
      :reviewed_at => reviewed_at,
      :locked => locked,
      :tasks => tasks.collect do |t|
        t.to_yaml_obj
      end,
    }
  end

  def self.load_yaml_obj(user, pd)
    parent = pd[:parent] ? user.projects.find_by_name(pd[:parent]) : nil
    data = {
      :name=> pd[:name],
      :review_interval => pd[:review_interval],
      :parent => parent,
      :created_at => pd[:created_at],
      :updated_at => pd[:updated_at],
      :reviewed_at => pd[:reviewed_at],
      :locked => pd[:locked],
      :use_record_timestamps => false
    }
    prj = user.with_myscope do
      user.projects.create!(data)
    end
    pd[:tasks].each do |td|
      Task.load_yaml_obj(prj, td)
    end
  end

  class LockedError < RuntimeError
  end

  private

  def my_task_query
    q = Task.query.trashed_at_is_null
    q.user_id_eq(user.id)
    q.project_id_eq(self.id)
    q
  end
end
