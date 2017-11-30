class CuiController < ApplicationController
  before_filter :authorize
  around_filter :with_users_scope

  def index
    @inbox = @user.inbox

    #context = ContextTag.find_by_name(params[:na])
    @context = nil
    @context = ContextTag.find(params[:na]) if params[:na]
    @next_actions = @user.next_actions(@context)

    @sch = nil
    @sch = Time.parse(params[:sch]) if params[:sch]
    @sch = Time.today.since(7.days) unless @sch
    @schedules = @user.schedules(@sch)

    @project_to_review = @user.project_to_review
    today_cond =['done_at > ? and done_at < ?',
                 Time.now.beginning_of_day,
                 Time.now.tomorrow.beginning_of_day,
                ]
    @done_today = @user.tasks.find(:all, :conditions=>today_cond, :order=>'done_at')
  end

  def inbox
    push_url :action=>:inbox
    @inbox = @user.inbox
  end

  def add_task
    if request.method == :post
      @user.commands.do_create_task(params[:text])
      redirect_back
    end
  end

  def edit_task
    @task = Task.find(params[:id])
    return unless request.method == :post

    next_task = nil
    continue = params[:continue]

    #task_attr = params[:task].merge(:tag => params[:tag])
    task_attr = params[:task]
    case params[:commit]
    when 'settag'
      @user.commands.do_update_task(@task.id, task_attr, params[:tv])
      next_task = @task
      continue = true
    when 'update'
      @user.commands.do_update_task(@task.id, task_attr, params[:tv])
      next_task = @user.inbox.first
    when 'update & next'
      @user.commands.do_update_task(@task.id, task_attr, params[:tv])
      next_task = @user.inbox.first
      if next_task
        redirect_to :id=>next_task.id, :action=>:edit_task
      else
        redirect_back
      end
    when 'done'
      @user.commands.do_task_done(@task)
      next_task = @user.inbox.first
    else
      raise "can't happen"
    end

    if continue and next_task
      redirect_to :id=>next_task.id, :action=>:edit_task
    else
      redirect_back
    end
  end

  def list_projects
    @projects = @user.root_project.tree.collect do |level, prj|
      {
        :level => level,
        :project => prj
      }
    end
  end

  def projects
    @project = Project.find(params[:id])
    done_cond = ['done_at is not null and trashed_at is null']
    @task_done = @project.tasks.find(:all, :conditions=>done_cond, :order=>'done_at')
    not_done_cond = ['done_at is null and trashed_at is null']
    @next_action_task, @tasks =
      * @project.tasks.find(:all, :order => 'updated_at', :conditions => not_done_cond).partition do |t|
        t.tags.any? { |tag| tag.kind_of?(ContextTag) }
    end
  end

  def add_project
    if request.method == :post
      @user.commands.do_create_project(params[:parent][:id], params[:name])
      redirect_back
    end
  end

  def edit_project
    @project = Project.find(params[:id])
    if request.method == :post
      @project.update_attributes(params[:project])
      @user.commands.do_update_project(@project)
    end
  end

  def record_project_review
    @project = Project.find(params[:id])
    @user.commands.do_project_review(@project)
    redirect_back
  end

  def list_tags
    @tags = Hash.new do |h, k|
      h[k] = []
    end
    @user.tags.find(:all).each do |t|
      @tags[t.class.name.intern] << t
    end
  end

  def tags
    @the_tag = Tag.find(params[:id])
    #@tasks = @the_tag.tasks.find(:all)
    @tasks = @the_tag.tasks
  end

  private

  def push_url(url)
    session[:last_url] ||= []
    session[:last_url].push url
  end

  def redirect_back
    if session[:last_url] and session[:last_url].first
      redirect_to session[:last_url].pop
    else
      redirect_to :action=>:index
    end
  end
end
