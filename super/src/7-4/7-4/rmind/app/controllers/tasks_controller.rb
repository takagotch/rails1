class TasksController < ApplicationController
  before_filter :authorize
  around_filter :with_users_scope

  def index
    q = Task.query.done_at_is_null.trashed_at_is_null
    @tasks = q.find(:all, :order=>'created_at desc')
    @tasks_by_date = Task.tasks_by_date(@tasks, :created_at)
    record_url url_for(:action=>:index)
  end

  def done
    q = Task.query.done_at_is_not_null.trashed_at_is_null
    @tasks = q.find(:all, :order=>'done_at desc')
    @tasks_by_date = Task.tasks_by_date(@tasks, :done_at)
    record_url url_for(:action=>:done)
  end

  def trashed
    q = Task.query.trashed_at_is_not_null
    @tasks = q.find(:all, :order=>'trashed_at desc')
    @tasks_by_date = Task.tasks_by_date(@tasks, :trashed_at)
    record_url url_for(:action=>:trashed)
  end

  def show
    @task = Task.find(params[:id])
  end

  def new
    @text = params[:text]
    @task_url = params[:url]
    @memo = params[:memo]
  end

  def edit
    @task = Task.find(params[:id])
    return unless request.method == :post

    task_attr = params[:task]
    #task_attr[:tag] = params[:tag]
    case params[:commit]
    when 'settag'
      @user.commands.do_update_task(@task.id, task_attr, params[:tv])
      redirect_to :id=>@task.id, :action=>:edit
    when 'update'
      @user.commands.do_update_task(@task.id, task_attr, params[:tv])
      redirect_back
    when nil
      # do nothing
    else
      raise "can't happen #{params}"
    end
  end

  def toggle_done
    @current_task = Task.find(params[:id])
    command_action do
      if @current_task.done?
        @user.commands.do_task_undone(@current_task)
      else
        @user.commands.do_task_done(@current_task)
      end
    end
    redirect_back
  end

  def untrash
    @current_task = Task.find(params[:id])
    command_action do
      @user.commands.do_task_untrash(@current_task)
    end
    redirect_back
  end

  def create
    if request.method == :post
      command_action do
        cmd = @user.commands.do_create_task(params[:text], params[:url], params[:memo])
        @current_task = cmd.task
        redirect_back
      end
    else
      render :action => "new"
    end
  rescue ActiveRecord::RecordInvalid
    render :action => "new"
  end

  def update
    @task = Task.find(params[:id])

    if @task.update_attributes(params[:task])
      flash[:notice] = 'Task was successfully updated.'
      redirect_to task_url(@task)
    else
      render :action => "edit"
    end
  end

  def destroy
    @task = Task.find(params[:id])
    if @task.trashed?
      @task.destroy
    else
      command_action do
        cmd = @user.commands.do_task_trash(@task)
      end
    end

    redirect_back
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
    @user.last_command.destroy
    raise
  end

end
