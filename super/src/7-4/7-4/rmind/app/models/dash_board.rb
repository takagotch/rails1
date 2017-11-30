module DashBoard
  include CriteriaQueryPlus
  def inbox
    q = Task.query.status_eq(Task::Status::Inbox)
    q.join('taggings').join('tag')
    q.find(:all, :order => 'updated_at')
  end

  def inbox_old
    q = current_tasks.project_id_eq(root_project.id)
    q.join('taggings').join('tag')
    exclude_tag_class = [ContextTag, ScheduleTag, DelegationTag]
    q.find(:all, :order => 'updated_at').find_all do |task|
      not task.tags.any? { |tag| exclude_tag_class.include?(tag.class) }
    end
  end

  def next_actions(context=nil)
    q = Task.query.status_eq(Task::Status::NextAction)
    q.join('taggings').join('tag')
    check =
      case context
      when nil
        nil
      when String
        proc { |t| t.name == context }
      when ContextTag
        proc { |t| t == context }
      when Array
        case context.first
        when String
          proc { |t| context.include?(t.name) }
        when Integer
          proc { |t| context.include?(t.id) }
        when nil
          nil
        else
          raise "can't happen #{context.first.class}"
        end
      else
        raise "can't happen #{context.class}"
      end
    ret  = q.find(:all, :order => 'updated_at')
    if check
      ret.find_all do |task|
        task.tags.any? { |tag| check.call(tag) }
      end
    else
      ret
    end
  end

  def next_actions_old(context=nil)
    q = current_tasks
    case context
    when nil
      q.join('taggings').join('tag').type_eq(ContextTag.name)
    when String
      q.join('taggings').join('tag').name_eq(context)
    when ContextTag
      q.join('taggings').join('tag').id_eq(context.id)
    when Array
      case context.first
      when String
        q.join('taggings').join('tag').name_in(context)
      when Integer
        q.join('taggings').join('tag').id_in(context)
      else
        raise "can't happen #{context.first.class}"
      end
    else
      raise "can't happen #{context.class}"
    end
    q.find(:all, :order => 'updated_at').collect do |t|
      t.reload
    end
  end

  def schedules(to=nil)
    q = Schedule.query.user_id_eq(self.id)
    case to
    when String
      q.date_lte(Time.parse(to)) if to
    when Time
      q.date_lte(to) if to
    when nil
      # do nothing
    else
      raise "can't happen #{to.class}"
    end
    qt = q.join("schedule_tagging").join("task")
    qt.done_at_is_null.trashed_at_is_null
    q.find(:all, :order => 'schedules.date, schedules.from').collect do |sch|
      sch.schedule_tagging.task
    end
  end

  def tasks_done(since=nil)
    q = Task.query.status_eq(Task::Status::Done)
    q.done_at_gte(since) if since
    q.find(:all, :order => 'done_at')
  end

  def project_to_review
    q = Project.query.user_id_eq(self.id)
    q.or << q.reviewed_at_is_null << q.next_review_lte(Time.now)
    q.find(:order=>'next_review')
  end

  def project_to_review_old
    q = Project.query.user_id_eq(self.id)
    exp = Criteria::LteExpression.new(%[adddate(reviewed_at, review_interval)], Time.now)
    def exp.conditions
      " ( #{@name} #{operator} ? ) "
    end

    q.or << q.reviewed_at_is_null << exp
    q.find(:order=>'reviewed_at')
  end

  private
  def current_tasks
    Task.query.done_at_is_null.trashed_at_is_null
  end
end
