require File.dirname(__FILE__) + '/../spec_helper'
require 'spec/common'

describe CuiController do
  it_should_behave_like "TestWithOneUser"

  before(:each) do
    login
  end

  #Delete this example and add some real ones
  it "should use CuiController" do
    controller.should be_an_instance_of(CuiController)
  end

  it "has inbox" do
    get :inbox
    response.should be_success
    assigns(:inbox).should == []
  end

  it "can add task" do
    get :inbox
    get :add_task
    response.should be_success
    post :add_task, :text=>'aaaa'
    response.should redirect_to(:action => 'inbox')
    follow_redirect
    assigns(:inbox).size.should == 1
  end

  it "can edit task" do
    task_id = add_task('aaaa')
    get :edit_task, :id=>task_id
    response.should be_success
    post :edit_task, :id=>task_id, :task=> { :text=>'bbbb' }, :commit=>'update'
    response.should redirect_to(:action => 'index')
    t = Task.find(task_id)
    t.text.should == 'bbbb'
    assigns(:inbox).size.should == 1
  end

  it "shows next actions" do
    task_id = add_task('aaa')
    task = Task.find(task_id)
    task.tag = '@office @home'
    task.save!
    get :index
    assigns(:inbox).size.should == 0
    assigns(:next_actions).size.should == 1
    get :index, :na=>ContextTag.find_by_name('@office')
    assigns(:next_actions).size.should == 1
    get :index, :na=>ContextTag.find_by_name('@home')
    assigns(:next_actions).size.should == 1

    task.tag = '@office'
    task.save!
    get :index, :na=>ContextTag.find_by_name('@office')
    assigns(:next_actions).size.should == 1
    get :index, :na=>ContextTag.find_by_name('@home')
    assigns(:next_actions).size.should == 0
  end

  it "can make task done" do
    task_id = add_task('aaaa')
    get :edit_task, :id=>task_id
    response.should be_success
    post :edit_task, :id=>task_id, :task=> { :text=>'bbbb' }, :commit=>'done'
    response.should redirect_to(:action => 'index')
    follow_redirect
    t = Task.find(task_id)
    t.done_at.should_not be_nil
    assigns(:inbox).size.should == 0
    assigns(:done_today).size.should == 1
  end

  it "can edit tag of task" do
    task_id = add_task('aaaa')
    get :edit_task, :id=>task_id
    response.should be_success
    post :edit_task, :commit=>'settag', :id=>task_id, :task=> { :text=>'bbbb', :tag=>'aaa' }
    response.should redirect_to(:action=>'edit_task', :id=>task_id)
    t = Task.find(task_id)
    t.text.should == 'bbbb'
    t.tag.should == 'aaa'
    Tag.find_by_name('aaa').tasks.first.should == t
    post :edit_task, :commit=>'settag', :id=>task_id, :task=> { :text=>'bbbb', :tag=>'xxx yyy' }
    response.should redirect_to(:action=>'edit_task', :id=>task_id)
    t = Task.find(task_id)
    t.text.should == 'bbbb'
    t.tag.should == 'xxx yyy'
    Tag.find_by_name('xxx').tasks.first.should == t
    Tag.find_by_name('yyy').tasks.first.should == t
  end

  it "can edit tagging value of task" do
    task_id = add_task('aaaa')
    get :edit_task, :id=>task_id
    response.should be_success
    post :edit_task, :commit=>'update', :tv=>{ "20070822" => { "place" => "somewhere"}}, :id=>task_id, :task=> { :text=>'bbbb' , :tag=>'20070822'}
    response.should redirect_to(:action => 'index')
    follow_redirect
    response.should be_success
    t = Task.find(task_id)
    t.load_tagging_value
    t.text.should == 'bbbb'
    t.tagging_value['20070822'][:place].should == 'somewhere'
  end

  it "can move task to a project" do
    root = @user.root_project
    p1 = root.sub_projects.create(:name=>'p1')
    Time.with_mock_time do
      add_task 'aaaa'
      Time.advance(1)
      add_task('bbbb',2)
    end
    task_id = @user.inbox.first.id
    get :edit_task, :id=>task_id
    assigns(:task).text.should == 'aaaa'
    response.should be_success
    post :edit_task, :commit=>'update', :id=>task_id, :task=> { :text=>'aaaa', :project_id=>p1.id }, :continue=>true
    @user.inbox.size.should == 1
    task_id = @user.inbox.first.id
    response.should redirect_to(:action => 'edit_task', :id=>task_id)
    follow_redirect
    assigns(:task).text.should == 'bbbb'
    post :edit_task, :commit=>'update', :id=>assigns(:task).id, :task=> { :text=>'bbbb', :project_id=>p1.id }
    response.should redirect_to(:action => 'index')
    follow_redirect
    Task.find_by_text('aaaa').project.should == p1
    Task.find_by_text('bbbb').project.should == p1
    assigns(:inbox).size.should == 0
  end

  it "can continue editting tasks" do
    task_data = {
      :text=>'xxxx',
      :tag =>'@office'
    }
    t1 = t2 = t3 = nil
    Time.with_mock_time do
      t1 = add_task('aaaa')     ; Time.advance(1)
      t2 = add_task('bbbb', 2)  ; Time.advance(1)
      t3 = add_task('cccc', 3)
    end
    #p @user.inbox.collect {  |t| [t.id, t.text]}
    get :edit_task, :id=>t1
    response.should be_success
    post :edit_task, :id=>t1, :task=> task_data, :commit=>'update', :continue=>true
    response.should redirect_to(:action => 'edit_task', :id=>t2)
    follow_redirect
    assigns(:task).id.should == t2
    post :edit_task, :id=>t2, :task=> task_data, :commit=>'update', :continue=>true
    response.should redirect_to(:action => 'edit_task', :id=>t3)
    follow_redirect
    assigns(:task).id.should == t3
    post :edit_task, :id=>t3, :task=> task_data, :commit=>'update', :continue=>true
    response.should redirect_to(:action => 'index')
    follow_redirect
    assigns(:inbox).size.should == 0
  end

  it "has dashboard" do
    get :index
    response.should be_success
    assigns(:inbox).should == []
  end

  it "can make a project" do
    root = @user.root_project
    root.should have(0).sub_projects
    login
    post :add_project, :name => 'prj1', :parent => { :id=> root.id }

    root.reload
    root.should have(1).sub_projects
    prj = root.sub_projects.first
    prj.name.should == 'prj1'
  end

  it "can edit a project" do
    prj_id = add_project('prj1')
    get :edit_project, :id=>prj_id
    assigns(:project).should == Project.find(prj_id)
    post :edit_project, :id=>prj_id, :project=>{ :name=>'xyz', :review_interval=>'7', :goal=> 'my goal'}
    prj = Project.find(prj_id)
    prj.name.should == 'xyz'
    prj.review_interval.should == 7
    prj.goal.should == 'my goal'
  end

  private

  def login
    #post '/user/login', :user => { :login=>'u1', :password=>'abc' }
    #session[:user_id].should_not be_nil
    session[:user_id] = @user.id
  end

  def add_task(name, size=1)
    post :add_task, :text=>name
    response.should redirect_to(:action => 'index')
    follow_redirect
    assigns(:inbox).size.should == size
    assigns(:inbox).last.id
  end

  def add_project(name)
    root = @user.root_project
    root.should have(0).sub_projects
    login
    post :add_project, :name => name, :parent => { :id=> root.id }
    root.reload
    root.should have(1).sub_projects
    root.sub_projects.first.id
  end
end
