require File.dirname(__FILE__) + '/../spec_helper'
require 'spec/common'

describe User do
  it_should_behave_like "TestWithOneUser"

  it "has login name and email" do
    @user.login.should == "u1"
    @user.email.should == "tnakajima@brain-tokyo.jp"
  end

  it "can change email" do
    @user.email = "tnaka@dc4.so-net.ne.jp"
    @user.save!
    user = User.find_by_login("u1")
    user.email.should == "tnaka@dc4.so-net.ne.jp"
  end

  it "has root_projects" do
    root_project = @user.root_project
    root_project.should_not be_nil
    root_project.name.should == "root"
    @user.projects.should include(root_project)
  end

  it "can have many projects" do
    root_project = @user.root_project
    root_project.should_not be_nil
    root_project.name.should == "root"
    root_project.sub_projects.create(:name => 'xxxx')
    root_project.sub_projects.create(:name => 'yyyy')
    @user.should have(3).projects
  end

  it "can't have two root projects" do
    root_project2 = @user.projects.create(:name=>'root2')
    @user.should have(2).projects
    @user.root_project.should_not == root_project2
    @user.root_project.sub_projects.should include(root_project2)
  end

  it "has tags" do
    @user.should have(0).tags
    t = @user.tags.create(:name=>'aaa')
    @user.should have(1).tags
    @user.tags.should include(t)
  end

  it "deletes all projects on destroy" do
    root_project = @user.root_project
    p2 = root_project.sub_projects.create(:name => 'project2')
    Project.find(root_project.id).should_not be_nil
    Project.find(p2.id).should_not be_nil
    @user.root_project.locked = false
    @user.root_project.save!
    @user.destroy
    proc { Project.find(root_project.id) }.should raise_error
    proc { Project.find(p2.id) }.should raise_error
  end

  it "deletes all tasks on destroy" do
    t1 = Task.create :text=>'t1', :user=>@user
    t2 = Task.create :text=>'t2', :user=>@user
    Task.find(t1.id).should_not be_nil
    Task.find(t2.id).should_not be_nil
    @user.root_project.locked = false
    @user.root_project.save!
    @user.destroy
    proc { Task.find(t1.id) }.should raise_error
    proc { Task.find(t2.id) }.should raise_error
  end

  it "deletes all tags on destroy" do
    t1 = Tag.create :name=>'t1', :user=>@user
    t2 = Tag.create :name=>'t2', :user=>@user
    Tag.find(t1.id).should_not be_nil
    Tag.find(t2.id).should_not be_nil
    @user.root_project.locked = false
    @user.root_project.save!
    @user.destroy
    proc { Tag.find(t1.id) }.should raise_error
    proc { Tag.find(t2.id) }.should raise_error
  end

  it "has created_at and updated_at" do
    u = nil
    Time.with_mock_time("2007-1-2 3:4:5") do
      u = User.create(:login=>'dummy', :email=>'dummy')
      u.created_at.should == Time.parse("2007-1-2 3:4:5")
      u.updated_at.should == Time.parse("2007-1-2 3:4:5")
      Time.advance(1.hour)
      u.login = "bbbb"
      u.save!
      u.created_at.should == Time.parse("2007-1-2 3:4:5")
      u.updated_at.should == Time.parse("2007-1-2 4:4:5")
    end
  end
  it "can find tag by name" do
    t1 = Task.create :text=>'t1', :user=>@user
    t1.tag = "aaa bbb"
    t1.save!
    tag = @user.find_tag("aaa")
    tag.should be_kind_of(PlainTag)
  end
end

describe User,"Authentication" do
  it "holds hashed password with salt" do
    user = User.create :login=>'u1', :password=>'aaa'
    user.password_salt.should_not be_nil
    user.password_hash.should_not be_nil
  end

  it "can authenticate" do
    User.create :login=>'u1', :password=>'aaa', :email=>'xxx'
    u = User.authenticate('u1', 'aaa')
    u.should be_kind_of(User)
    u.email.should == 'xxx'
  end

  it "can check bad password" do
    User.create :login=>'u1', :password=>'abc', :email=>'dummy'
    proc { User.authenticate('u1', 'aaa') }.should raise_error(User::AuthenticationError)
    proc { User.authenticate('u1', 'aba') }.should raise_error(User::AuthenticationError)
    User.authenticate('u1', 'abc').should be_kind_of(User)
  end
end


