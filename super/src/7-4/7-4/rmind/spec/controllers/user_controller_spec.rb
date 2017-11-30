require File.dirname(__FILE__) + '/../spec_helper'
require 'active_support/breakpoint'
include Breakpoint

describe UserController do
  controller_name :user
  integrate_views

  before(:each) do
    @user = User.create :login=>'u1', :password=>'abc', :email=>'tnaka@dc4.so-net.ne.jp'
  end

  it "should use UserController" do
    controller.should be_an_instance_of(UserController)
  end

  it "show login form" do
    controller.should be_an_instance_of(UserController)
    get 'login'
    response.should be_success
    response.should render_template("user/login")
    response.should have_tag("html")
    response.should have_tag("input")
  end

  it "login successful" do
    post 'login', :user => { :login=>'u1', :password=>'abc' }

    session[:user_id].should == @user.id
    response.should redirect_to(:controller=>'main', :action => 'index')
  end

  it "login unsuccessful" do
    post 'login', :user => { :login=>'u1', :password=>'xyz' }
    response.should be_success

    session[:user_id].should be_nil
  end

  it "can signup" do
    User.find_by_login('new_user').should be_nil

    get :signup
    response.should be_success

    post :signup, :user=> {
      :login=>'new_user',
      :password=>'xyz',
      :password_confirmation=>'xyz',
      :email=>'tnakajima@brain-tokyo.jp'
    }
    response.should redirect_to(:controller=>'user', :action => 'login')

    u = User.find_by_login('new_user')
    u.should_not be_nil
    u.root_project.should_not be_nil
    u.email.should == 'tnakajima@brain-tokyo.jp'

    # validate with template
    MemoTag.find(:first, :conditions=>{ :user_id=>u.id, :name=>'memo' }).should_not be_nil
    u.root_project.sub_projects.count.should == 5
    # puts u.root_project.sub_projects.collect {  |p| p.name }

    post 'login', :user => { :login=>'new_user', :password=>'xyz' }
    response.should redirect_to(:controller=>'main', :action => 'index')
    session[:user_id].should == u.id
  end

  it "can edit user" do
    post :signup, :user=> {
      :login=>'new_user',
      :password=>'xyz',
      :password_confirmation=>'xyz',
      :email=>'tnakajima@brain-tokyo.jp'
    }
    response.should redirect_to(:controller=>'user', :action => 'login')

    u = User.find_by_login('new_user')
    u.should_not be_nil
    post 'login', :user => { :login=>'new_user', :password=>'xyz' }
    response.should redirect_to(:controller=>'main', :action => 'index')

    get :edit
    response.should be_success

    post :edit, :user => { :login=>'new_user', :password=>'xyz', :email=>'tnaka@dc4.so-net.ne.jp' }
    u = User.find_by_login('new_user')
    u.email.should == 'tnaka@dc4.so-net.ne.jp'
  end

  it "can delete user" do
    post :signup, :user=> {
      :login=>'new_user',
      :password=>'xyz',
      :password_confirmation=>'xyz',
      :email=>'tnakajima@brain-tokyo.jp'
    }
    response.should redirect_to(:controller=>'user', :action => 'login')
    user_id = User.find_by_login('new_user').id
    post :delete

    proc { User.find(user_id) }.should raise_error(ActiveRecord::RecordNotFound)
    response.should redirect_to(:controller=>'user', :action => 'login')

  end

  it "reject signup without password" do
    User.find_by_login('new_user').should be_nil

    get :signup
    response.should be_success

    post :signup, :user=> {
      :login=>'new_user',
      :email=>'tnakajima@brain-tokyo.jp'
    }
    flash[:error].should_not be_nil
    response.should be_success
  end

  it "logout" do
    post 'login', :user => { :login=>'u1', :password=>'abc' }

    session[:user_id].should == @user.id
    response.should redirect_to(:controller=>'main', :action => 'index')

    get 'logout'
    session[:user_id].should be_nil
    get 'main/index'
    response.should redirect_to(:controller=>'user', :action => 'login')
  end
end
