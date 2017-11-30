class MainController < ApplicationController
  before_filter :authorize
  around_filter :with_users_scope

  def index
    @inbox = @user.inbox
    @na = {}
    @next_actions = @user.next_actions(parse_na_cond)
    @schedules = @user.schedules(parse_sch_cond)
    @tasks_done = @user.tasks_done(parse_done_cond)
    @project_to_review = @user.project_to_review
    record_url url_for(:action=>:index)
  end

  def add_task
    if request.method == :post
      command_action do
        cmd = @user.commands.do_create_task(params[:text])
        @current_task = cmd.task
        index
      end
    else
      redirect_to :action=>:index
    end
  end

  def show_task
    if request.method == :post
      index
      @cmd = params[:cmd]
      @current_task = nil
      @current_task = Task.find(params[:id]) if params[:id]
      @status_before = nil
      @status_before = @current_task.status if @current_task
    else
      redirect_to :action=>:index
    end
  end

  def show_task_window
    @show_task = Task.find(params[:id])
    render :partial => 'show_task'
  end

  def edit_task
    @current_task = Task.find(params[:id])
    @status_before = @current_task.status
    old_tag = @current_task.tag
    unless request.method == :post
      @cmd = 'edit'
      index
      render :action=>:show_task
      return
    end

    task_attrs = params[:task] || {}
    command_action do
      @user.commands.do_update_task(params[:id], task_attrs, params[:tv])
    end
    @current_task.reload
    index
    @cmd = 'close'
    render :action=>:show_task
  rescue ActiveRecord::RecordInvalid
    render :action=>:error
  end

  def toggle_task_done
    @current_task = Task.find(params[:id])
    @status_before = @current_task.status
    unless request.method == :post
      redirect_to :action=>:index
      return
    end

    command_action do
      if @current_task.done?
        @user.commands.do_task_undone(@current_task)
      else
        @user.commands.do_task_done(@current_task)
      end
    end
    @current_task.reload
    index
    @cmd = 'close'
    render :action=>:show_task
  end

  def undo
    unless request.method == :post
      redirect_to :action=>:index
      return
    end

    @user.reload
    desc = @user.last_command.description
    @user.commands.undo
    @user.reload
    flash[:undo_link] = "more undo of #{@user.last_command.description}" if @user.last_command
    flash[:message] = "Undo completed (#{desc})"
    redirect_to :action=>:index
  rescue
    @user.last_command.destroy
    redirect_to :action=>:index
  end

  def complete_tag
    q = Tag.query
    regexp = "#{params[:task][:tag]}%"
    q.name_like(regexp)
    @tags = q.find(:all, :limit=>10).collect { |t| t.name }
    render :inline => "<ul><<li:tags>></ul>", :type => :a2html
  end

  def update_tag
    task = Task.find(params[:id])
    tag = params[:task][:tag]
    edit_inbox = params[:cmd]

    command_action do
      @user.commands.do_update_task(task.id, :tag=>tag)
    end
    if edit_inbox
      render :update do |page|
        @edit_task = @current_task = task
        page[:edit_task].reload
        page[:message_area].reload
      end
    else
      index
      render :action=>:show_task
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
    @user.last_command.destroy
    raise
  end

  def parse_na_cond
    na_array = []
    param = params[:na] || session[:na]
    if param.blank?
      ContextTag.find(:all).each do |c|
        @na[c.id] = true
        na_array << c.id
      end
    else
      param.each do |c|
        @na[c.to_i] = true
        na_array << c.to_i
      end
    end
    session[:na] = na_array
    na_array
  end

  def parse_sch_cond
    @sch = session[:sch] = params[:sch] || session[:sch]
    @sch = Time.now + 7.days if @sch.blank?
    @sch = @sch.to_time unless @sch.kind_of?(Time)
    @sch
  end

  def parse_done_cond
    @done_since = session[:show_done_since] = params[:show_done_since] || session[:show_done_since]
    @done_since = Time.now  if @done_since.blank?
    @done_since = @done_since.to_time unless @done_since.kind_of?(Time)
    @done_since
  end
end

