class TaskController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @toDoTasks = Task.find(:all, :conditions=>["status=?","todo"],:order=> "priority desc,updated_on desc")
    @doingTasks = Task.find(:all, :conditions=>["status=?","doing"],:order=> "updated_on desc")
    @doneTasks = Task.find(:all, :conditions=>["status=?","done"],:order=> "updated_on desc")
  end

  def show
    @task = Task.find(params[:id])
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(params[:task])
    if @task.save
      flash[:notice] = 'Task was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])
    if @task.update_attributes(params[:task])
      flash[:notice] = 'Task was successfully updated.'
      redirect_to :action => 'show', :id => @task
    else
      render :action => 'edit'
    end
  end

  def destroy
    Task.find(params[:id]).destroy
    render :update do |page|
        page.visual_effect :fade, "#{params[:id]}", :duration => 0.6
    end
  end
  def change_status
    @task = Task.find(params[:id])
    if @task.update_attributes(:status => params[:status])
      render :update do |page|
        page.visual_effect :highlight, "#{params[:id]}", :duration => 0.6
      end
    end
  end

end
