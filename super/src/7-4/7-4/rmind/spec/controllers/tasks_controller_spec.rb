require File.dirname(__FILE__) + '/../spec_helper'
require 'spec/common'

describe TasksController do
  it_should_behave_like "TestWithOneUser"

  it "should use TasksController" do
    controller.should be_an_instance_of(TasksController)
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

  it "POST 'create' task should be successful" do
    login
    get 'new'
    response.should be_success
    add_task :text=>'aaa'
    response.should redirect_to(:action => :index, :controller=>:main)
  end

  it "POST 'create' task can set url" do
    login
    get 'new'
    response.should be_success
    task_id = add_task :text=>'amrita2', :url=>'http://amrita2.rubyforge.org/'
    task = Task.find(task_id)
    task.text.should == 'amrita2'
    task.url.should == 'http://amrita2.rubyforge.org/'
  end

  it "POST 'create' task can set memo" do
    login
    get 'new'
    response.should be_success
    task_id = add_task :text=>'amrita2', :url=>'http://amrita2.rubyforge.org/', :memo=>'abc'
    task = Task.find(task_id)
    task.text.should == 'amrita2'
    task.url.should == 'http://amrita2.rubyforge.org/'
    task.tag.should == 'memo'
    task.load_tagging_value
    task.tagging_value['memo'][:memo].should == 'abc'
  end

  it "POST 'edit' modify task " do
    login
    get 'new'
    response.should be_success
    task_id = add_task :text=>'amrita2', :url=>'http://amrita2.rubyforge.org/', :memo=>'abc'
    get :edit, :id=>task_id
    response.should be_success
    post :edit, :id=>task_id, :task => { :text=>'xyz' }, :commit=>'update'
    task = Task.find(task_id)
    task.text.should == 'xyz'
    task.url.should == 'http://amrita2.rubyforge.org/'
    task.load_tagging_value
    task.tagging_value['memo'][:memo].should == 'abc'
    response.should redirect_to(:action => :index, :controller=>:main)
  end

  it "POST 'edit' and return to main " do
    login
    get 'new'
    response.should be_success
    task_id = add_task :text=>'amrita2', :url=>'http://amrita2.rubyforge.org/', :memo=>'abc'
    get :edit, :id=>task_id
    response.should be_success
    session[:last_url] = '/main/index'
    post :edit, :id=>task_id, :task => { :text=>'xyz' }, :commit=>'update'
    task = Task.find(task_id)
    task.text.should == 'xyz'
    response.should redirect_to(:controller=>:main, :action => :index)
  end

  it "POST 'destroy' task should be successful" do
    login
    task_id = add_task :text=>'aaa'
    post 'destroy', :id=>task_id
    t = Task.find(task_id)
    t.should_not be_nil
    t.trashed_at.should_not be_nil
  end

  it "GET 'index' should return task by date" do
    Time.with_mock_time('2007-12-21') do
      login
      add_task :text=>'aaa'
      get 'index'
      assigns(:tasks_by_date).size.should == 1
      dt = assigns(:tasks_by_date).first
      dt[:date].should == Time.parse('2007-12-21')
      dt[:tasks].size.should == 1
      dt[:tasks].first.text.should == 'aaa'
      response.should be_success
    end
    Time.with_mock_time('2007-12-22') do
      add_task :text=>'bbb'
      add_task :text=>'ccc'
      get 'index'
      assigns(:tasks_by_date).size.should == 2
      response.should be_success
      dt = assigns(:tasks_by_date).first
      dt[:date].should == Time.parse('2007-12-22')
      dt[:tasks].size.should == 2
      dt[:tasks].first.text.should == 'bbb'
      dt[:tasks][1].text.should == 'ccc'

      dt = assigns(:tasks_by_date)[1]
      dt[:date].should == Time.parse('2007-12-21')
      dt[:tasks].size.should == 1
      dt[:tasks].first.text.should == 'aaa'
    end
  end

  def add_task(params)
    post 'create', params
    t = Task.find_by_text(params[:text])
    t.should_not be_nil
    t.id
  end

end
