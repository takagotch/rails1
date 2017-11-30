
module CommandProxy
  def do_create_task(*args)
    cmd(CreateTaskCommand, @owner, *args)
  end

  def do_update_task(task_id, attributes, tagging_value=nil)
    cmd(UpdateTaskCommand, @owner, task_id, attributes, tagging_value)
  end

  def do_move_task(task_id, project_id)
    cmd(MoveTaskCommand, @owner, task_id, project_id)
  end

  def do_create_project(parent_id, name, interval=nil)
    cmd(CreateProjectCommand, @owner, parent_id, name, interval)
  end

  def do_task_done(task)
    cmd(TaskStatusCommand, task, :done)
  end

  def do_task_undone(task)
    cmd(TaskStatusCommand, task, :undone)
  end

  def do_task_trash(task)
    cmd(TaskStatusCommand, task, :trash)
  end

  def do_task_untrash(task)
    cmd(TaskStatusCommand, task, :untrash)
  end

  def do_project_review(prj)
    cmd(ProjectReviewCommand,prj)
  end

  def do_update_project(prj)
    cmd(UpdateProjectCommand,prj)
  end

  def do_task_to_project(task)
    cmd(TaskToProjectCommand, task)
  end

  def cmd(cls, *args)
    cmd = cls.create(*args)
    cmd.do
  ensure
    while self.count > 10
      self.find(:first, :order=>'done_at').destroy
    end
  end

  def last_command
    self.find(:first, :order=>'done_at desc')
  end

  def undo
    last_command.undo.destroy
  end
end
