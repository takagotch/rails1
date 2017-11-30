module CuiHelper

  def select_project(obj, name)
    projects = @user.root_project.tree.collect do |level, prj|
      ["-" * level + prj.name, prj.id]
    end
    select(obj, name, projects)
  end
end
