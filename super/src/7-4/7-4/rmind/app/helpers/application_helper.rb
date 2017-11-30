# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def select_project(obj, name)
    projects = @user.root_project.tree.collect do |level, prj|
      ["-" * level + prj.name, prj.id]
    end
    select(obj, name, projects)
  end

  def task_window_link(task_id, text)
    link_to_remote text,
      :url=> { :controller=>:main, :action=>:show_task_window, :id=>task_id },
      :update => 'task_work',
      :success=> %[ TaskWindow.show() ; ]
  end

  def project_tree
    @user.root_project.tree.collect do |level, prj|
      {
        :name => "-" * level + prj.name,
        :id => prj.id
      }
    end
  end
end


