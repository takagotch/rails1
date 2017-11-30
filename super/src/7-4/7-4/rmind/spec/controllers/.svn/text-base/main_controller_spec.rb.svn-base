require File.dirname(__FILE__) + '/../spec_helper'
require 'spec/common'

describe MainController do
  it_should_behave_like "TestWithOneUser"

  #Delete these examples and add some real ones
  it "should use MainController" do
    controller.should be_an_instance_of(MainController)
  end

  it "reject access without login" do
    get :index
    response.should redirect_to(:controller=>:user, :action => :login)
  end

  it "GET 'index' should be successful" do
    login
    get 'index'
    response.should be_success
  end


  it "has inbox" do
    login
    get 'index'
    response.should be_success
    assigns(:inbox).should == []
  end

  it "has inbox with new tasks" do
    login
    task_id = add_task('aaa')
    get 'index'
    response.should be_success
    assigns(:inbox).size.should == 1
    assigns(:inbox).first.id.should == task_id
  end

  it "can add task" do
    login
    post :add_task, :text=>'abc'
    assigns(:inbox).size.should == 1
    task_id = assigns(:inbox).first.id
    assigns(:current_task).id.should == task_id
    assigns(:current_task).text.should == 'abc'
  end

  it "can show task" do
    login
    task_id = add_task('aaa')
    get 'index'
    response.should be_success
    assigns(:inbox).size.should == 1
    assigns(:inbox).first.id.should == task_id
    post 'show_task', :id=>task_id
    assigns(:current_task).id.should == task_id
    assigns(:current_task).text.should == 'aaa'
  end

  it "can edit task" do
    login
    task_id = add_task('aaa')
    get 'index'
    response.should be_success
    assigns(:inbox).size.should == 1
    assigns(:inbox).first.id.should == task_id
    get 'edit_task', :id=>task_id
    response.should be_success
    assigns(:current_task).id.should == task_id
    assigns(:current_task).text.should == 'aaa'
    post 'edit_task', :id=>task_id, :task => { :text=>'update', :url=>'http%3A%2F%2Fxxxx.com%2F' }
    t = Task.find(task_id)
    t.text.should == 'update'
    t.url.should == 'http://xxxx.com/'
  end


  it "show scheduled task at index" do
    Time.with_mock_time('20070901') do
      login
      task_id = add_task('aaa')
      post 'edit_task', :id=>task_id, :task => { :tag=>'20070901' }
      response.should be_success

      get 'index'
      response.should be_success
      assigns(:inbox).size.should == 0
      assigns(:next_actions).size.should == 0
      assigns(:schedules).size.should == 1

      post 'edit_task', :id=>task_id, :task => { :tag=>'20070910' }
      get 'index'
      assigns(:schedules).size.should == 0
      Time.advance(10.days)
      get 'index'
      assigns(:schedules).size.should == 1
    end
  end

  it "can make task done" do
    Time.with_mock_time('20070901') do
      login
      task_id = add_task('aaa')
      post 'toggle_task_done', :id=>task_id
      response.should be_success
      task = Task.find(task_id)
      task.status.should == Task::Status::Done
      task.done_at.should == Time.now
      Time.advance(1.day)
      post 'toggle_task_done', :id=>task_id
      response.should be_success
      task.reload
      task.status.should == Task::Status::Inbox
      task.done_at.should be_nil
    end
  end

  it "show tasks done" do
    Time.with_mock_time('20070901') do
      login
      task_id = add_task('aaa')
      post 'toggle_task_done', :id=>task_id
      response.should be_success
      task = Task.find(task_id)
      get 'index'
      assigns(:tasks_done).size.should == 1

      Time.advance(7.days+1)
      get 'index'
      assigns(:tasks_done).size.should == 0
    end
  end

  it "can edit tag" do
    login
    task_id = add_task('aaa')
    post 'update_tag', :id=>task_id, :task=>{  :tag=> 'xxx'}
    response.should be_success
    Task.find(task_id).tag.should == "xxx"
  end


  def add_task(name, size=1)
    post :add_task, :text=>name
    get :index
    assigns(:inbox).size.should == size
    assigns(:inbox).first.id
  end
end

