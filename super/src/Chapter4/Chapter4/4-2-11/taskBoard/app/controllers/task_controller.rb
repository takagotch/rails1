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
    
    @form_action = 'add_task'
    @form_button = 'タスクを追加する'
    #空のフォームにIDを渡す為、.newしておく
    @task=Task.new
  end

  def show
    @task = Task.find(params[:id])
  end

  def new
    @task = Task.new
  end

  def edit
    @task = Task.find(params[:id])
    @form_action = 'update'
    @form_button = 'タスクを編集する'
    #content属性に<br/>が含まれていた場合に"\n"に変換する(textarea表示用)
    @task.content = @task.content.gsub("<br/>", "\n")

    render :update do |page|
      #編集対象のタスクにvisual_effectをかける
      page.visual_effect :highlight, "#{@task.id}",  :duration => 0.4
      #フォームを削除する
      page[:task_form].remove
      #フォームを挿入する
      page.insert_html :top, 'task_form_block', :partial => 'form'
      #編集対象のタスクにvisual_effectをかける
      page.visual_effect :highlight, "#{@task.id}",  :duration => 0.6
    end
  end
  
  def update
    @task = Task.find(params[:id])
    @task.update_attributes(params[:task])
    #改行が入力されていた場合に<br/>に変換する
    @task.content = @task.content.gsub("\n","<br/>")
    @task.save
    render :update do |page|
      #_task.rhtmlを置き換える
      page.replace "#{@task.id}", :partial => 'task'
      #置き換えたタスクにvisual_effectをかける
      page.visual_effect :highlight, "#{@task.id}",  :duration => 0.4
      #フォームを追加用に戻すため、一旦削除する
      page[:task_form].remove
      #フォームのアクションを'add_task'にする
      @form_action = 'add_task'
      #ボタン表示文字列を追加用にする
      @form_button = 'タスクを追加する'
      @task.content=""
      @task.owner  =""
      #フォームを挿入する
      page.insert_html :top, 'task_form_block', :partial => 'form'
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

  def add_task
    @task = Task.new(params[:task])
    @task.status = 'todo'
    #改行が入力されていた場合に<br/>に変換する
    @task.content = @task.content.gsub("\n", "<br/>")
    @task.save
    
    render :update do |page|
      #フォームをリセットする
      page.call 'Form.reset', 'task_form'
      #要素'todoCaption'の後ろに_task.rhtmlを:partialで挿入する
      page.insert_html :top, 'todoCaption', :partial => 'task'
      #タスクのdraggableを維持する
      page.draggable "#{@task.id}"
      #追加したタスクにvisual_effectをかける
      page.visual_effect :highlight,"#{@task.id}",:duration => 1
    end
  end

  def recycle
    @task = Task.find(params[:id])
    if @task.update_attributes(:status => params[:status])
      render :update do |page|
        page.visual_effect :fade, "#{params[:id]}", :duration => 0.6
      end
    end
  end

  def confirm_recycle
    @recycles = Task.find(:all, :conditions=>["status=?","recycle"],:order=> "priority desc")
    @form_action = 'confirm_recycle'
  end
end
