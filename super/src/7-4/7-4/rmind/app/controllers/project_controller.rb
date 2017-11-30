class ProjectController < ApplicationController
  before_filter :authorize
  around_filter :with_users_scope

  def index
    @projects = @user.root_project.tree.collect do |level, prj|
      {
        :level => level,
        :project => prj
      }
    end
    record_url url_for(:action=>:index)
  end

  def show
    @project = Project.find(params[:id])
    @current_task = Task.find(params[:task_id]) if params[:task_id]
    @done_since = (@project.reviewed_at or Time.now)
    @tasks_done = @project.tasks_done(@done_since)
    @next_actions = @project.next_actions
    @processing_tasks = @project.processing_tasks
    @cmd = params[:cmd]
    record_url url_for(:action=>:show, :id=>@project.id)
  end

  def record_review
    @project = Project.find(params[:id])
    @user.commands.do_project_review(@project)
    redirect_to :action=>:index, :controller=>:main
  end

  def new
    @project = Project.new
    if params[:parent]
      @project.parent_project_id = params[:parent].to_i
      @project.review_interval = @project.parent.review_interval
    end
  end

  def create
    if request.method == :post
      prj_params = params[:project]
      command_action do
        cmd = @user.commands.do_create_project(prj_params[:parent_project_id], prj_params[:name], prj_params[:review_interval])
        redirect_back
      end
    else
      render :action => "new"
    end
  rescue ActiveRecord::RecordInvalid
    render :action => "new"
  end

  def update_name
    @project = Project.find(params[:id])
    @project.name = params[:value]
    @project.save!
    render :text=>@project.name
  end

  def update_goal
    @project = Project.find(params[:id])
    @project.goal = params[:value]
    @project.save!
    render :text=>@project.goal
  end

  def update_interval
    @project = Project.find(params[:id])
    @project.review_interval = params[:value]
    @project.save!
    render :text=>@project.review_interval.to_s
  end

  def move
    target_prj = Project.find(params[:target_id])
    if params[:id] =~ /prj_(\d+)/
      prj = Project.find($1)
      prj.parent = target_prj
      prj.save!
    end
    render :update do |page|
      page << "location.href='#{url_for(:action=>:index)}'"
    end
  end

  def move_task
    task_id = case params[:id]
         when /taskdrg_(\w+)/
           $1.to_i
         when /task_(\w+)/
           $1.to_i
         else
           params[:id].to_i
         end

    task = Task.find(task_id)
    prj = Project.find(params[:to_project_id])
    command_action do
      @user.commands.do_move_task(task.id, prj.id)
    end
    render :update do |page|
      #page << "location.href='#{url_for(:action=>:show, :id=>params[:from_project_id])}'"
      page << "location.reload() ; "
    end
  end

  def task_to_project
    task = Task.find(params[:id].gsub("task_", "").to_i)
    command_action do
      @user.commands.do_task_to_project(task)
    end
    render :update do |page|
      page << "location.href='#{url_for(:action=>:show, :id=>params[:from_project_id])}'"
    end
  end

  def show_task
    @current_task = Task.find(params[:id])
    @project = @current_task.project
    @done_since = (@project.reviewed_at or Time.now)
    @tasks_done = @project.tasks_done(@done_since)
    @next_actions = @project.next_actions
    @processing_tasks = @project.processing_tasks
    @cmd = params[:cmd]
    render :update do |page|
      page[:processing_tasks].reload
      page[:next_actions].reload
      page[:tasks_done].reload
    end
  end

  def update_tag
    task = Task.find(params[:id])
    tag = params[:task][:tag]
    edit_inbox = params[:cmd]

    command_action do
      @user.commands.do_update_task(task.id, :tag=>tag)
    end

    params[:id] = task.project_id
    show
    render :update do |page|
      page[:processing_tasks].reload
      page[:next_actions].reload
      page[:tasks_done].reload
    end
  end

  private

  def command_action(&block)
    flash[:notice] = flash[:undo_link] = flash[:message] = flash[:error] = ""
    yield
    flash[:undo_link] = "undo it"
    flash[:message] = @user.last_command.command_message
  rescue ActiveRecord::RecordInvalid
    @user.last_command.destroy
    flash[:error] = $!.to_s
    raise
  rescue
    @user.last_command.destroy if @user.last_command
    raise
  end

end
