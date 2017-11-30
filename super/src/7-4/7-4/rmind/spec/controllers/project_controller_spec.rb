require File.dirname(__FILE__) + '/../spec_helper'
require 'spec/common'

describe ProjectController do
  it_should_behave_like "TestWithOneUser"

  before(:each) do
    @prj = @user.root_project.sub_projects.create(:name=>'prj1')
  end

  #Delete these examples and add some real ones
  it "should use ProjectController" do
    controller.should be_an_instance_of(ProjectController)
  end

  it "reject access without login" do
    get :index
    response.should redirect_to(:controller=>:user, :action => :login)
  end

  it "GET 'index' should be successful" do
    login
    get 'index'
    response.should be_success
    prj = assigns(:projects)
    prj[0][:level].should == 0
    prj[0][:project].should == @user.root_project
    prj[1][:level].should == 1
    prj[1][:project].should == @prj
  end

  it "GET 'show' should be successful" do
    login
    get 'show', :id=>@prj.id
    response.should be_success
    assigns(:project).should == @prj
    assigns(:tasks_done).should == []
    assigns(:next_actions).should == []
    assigns(:processing_tasks).should == []
  end

  it "GET 'show' should show tasks" do
    t1 = @prj.tasks.create(:text=>'aaa')
    t1.record_done.save!
    t2 = @prj.tasks.create(:text=>'bbb')
    t2.tag = '@office' ; t2.save!
    t3 = @prj.tasks.create(:text=>'ccc')

    login
    get 'show', :id=>@prj.id
    response.should be_success
    assigns(:project).should == @prj
    assigns(:tasks_done).should == [t1]
    assigns(:next_actions).should == [t2]
    assigns(:processing_tasks).should == [t3]
  end

  it "POST 'record_review' should be successful" do
    login
    Time.with_mock_time('20070901') do
      get :show, :id=>@prj.id
      response.should be_success
      post 'record_review', :id=>@prj.id
      response.should redirect_to(:action => :index, :controller=>:main)
      get 'show', :id=>@prj.id
      response.should be_success
      assigns(:project).reviewed_at.should == Time.parse('20070901')
    end
  end

  it "POST 'create' should be successful" do
    login
    get :new
    response.should be_success
    post :create, :project => { :name=>'aaa', :parent_project_id=>@user.root_project.id}

    prj = Project.find_by_name('aaa')
    prj.should_not be_nil
    prj.name.should == 'aaa'
    prj.parent_project_id.should == @user.root_project.id
    prj.review_interval.should == @user.root_project.review_interval
  end

  it "in place edit project name" do
    login
    get :show, :id=>@prj.id
    response.should be_success

    post :update_name, :id=>@prj.id, :value=>'new project name'
    response.should be_success

    @prj.reload
    @prj.name.should == 'new project name'
  end

  it "move task" do
    login
    task = Task.create(:text=>'aaa', :user=>@user)
    post :move_task, :to_project_id=>@prj.id, :id=>"task_#{task.id}"
    response.should be_success

    task.reload.project.should == @prj
  end

  it "convert a task to a project" do
    login
    task = Task.create(:text=>'aaa', :project=>@prj)
    post :task_to_project, :from_project_id=>@prj.id, :id=>"task_#{task.id}"
    response.should be_success

    new_project = @prj.reload.sub_projects.first
    new_project.should_not be_nil
    new_project.name.should == task.text
    task.reload.project.should == new_project
  end

end
