module MainHelper
  def select_project(obj, name)
    projects = @user.root_project.tree.collect do |level, prj|
      ["-" * level + prj.name, prj.id]
    end
    select(obj, name, projects)
  end

  def select_project_tag(obj, name, project_id, options={})
    projects = @user.root_project.tree.collect do |level, prj|
      ["-" * level + prj.name, prj.id]
    end
    select(obj, name, projects, { :selected=>project_id }, options)
  end

  def context_tags
    q = ContextTag.query
    q.user_id_eq(@user.id)
    q.find
  end

end
