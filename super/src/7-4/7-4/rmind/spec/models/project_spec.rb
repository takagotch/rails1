require File.dirname(__FILE__) + '/../spec_helper'
require 'spec/common'

describe Project do
  it_should_behave_like "TestWithOneUser"

  it "has name" do
    p = Project.new(:user=>@user, :name=>'project1')
    p.save
    p.user.should == @user
    p.user.login.should == 'u1'
  end

  it "can have parent project" do
    p1 = Project.create(:user=>@user, :name=>'project1')
    p2 = Project.create(:name=>'project2', :parent => p1)
    p1.save
    p1.should have(1).sub_projects
    p2.parent.should == p1
    p2.user.should == @user
    p2.user.projects.find(p2.id).should_not be_nil

    p3 = p1.sub_projects.create(:name => 'project3', :parent => p1)
    p1.save
    p1.should have(2).sub_projects
    p3.parent.should == p1
    p3.user.should == @user
    p3.user.projects.find(p3.id).should_not be_nil
  end

  it "must be set user or parent on creation" do
    p1 = Project.new(:name=>'project1')
    p1.should_not be_valid
    p1 = Project.new(:user=>@user, :name=>'project1')
    p1.should be_valid
    p1.save

    p2 = Project.new(:parent => p1, :name=>'project2')
    p1.should be_valid
    p1.save
  end

  it "should have unique name" do
    p1 = Project.new(:user=>@user, :name=>'project1')
    p1.save
    p2 = Project.new(:user=>@user, :name=>'project1')
    proc { p2.save! }.should raise_error
  end

  it "should have unique name per user" do
    p1 = Project.new(:user=>@user, :name=>'project1')
    p1.save
    p2 = Project.new(:user=>@user, :name=>'project1')
    proc { p2.save! }.should raise_error

    user2 = User.create :login=>'u2', :email => 'tnakajima@brain-tokyo.jp', :firstname => 'Taku', :lastname => 'Nakajima'
    user2.initial_setup
    user2.save!

    p1 = Project.new(:user=>user2, :name=>'project1')
    p1.save
    p2 = Project.new(:user=>user2, :name=>'project1')
    proc { p2.save! }.should raise_error
  end

  it "has tasks" do
    @user.with_myscope do
      p1 = Project.create(:name=>'project1')
      p1.should have(0).tasks
      t = p1.tasks.create(:text=>'task1')
      t.user.should == @user
      t.text.should == "task1"
      p1.tasks << t
      t.project_id.should == p1.id
      p1.tasks.should include(t)
    end
  end

  it "can pass tasks to other project" do
    @user.with_myscope do
      p1 = Project.create(:name=>'project1')
      p1.should have(0).tasks
      p2 = Project.create(:name=>'project2')
      p2.should have(0).tasks
      t = p1.tasks.create(:text=>'task1')
      t.project.name.should == "project1"
      p1.tasks.should include(t)
      p2.tasks.should_not include(t)
      p2.tasks << t
      t.reload ; p1.reload ;p2.reload
      t.project.name.should == "project2"
      p1.tasks.should_not include(t)
      p2.tasks.should include(t)

    end
  end

  it "can record review date" do
    Time.with_mock_time("2007 1/1") do
      p1 = Project.create(:user=>@user, :name=>'project1', :review_interval=>7)
      p1.created_at.should == Time.parse("2007 1/1")
      p1.updated_at.should == Time.parse("2007 1/1")
      p1.reviewed_at.should be_nil
      Time.advance(1.day)
      p1.record_review
      p1.updated_at.should == Time.parse("2007 1/1")
      p1.reviewed_at.should == Time.parse("2007 1/2")
    end
  end

  it "knows next review date" do
    Time.with_mock_time("2007 1/1") do
      p1 = Project.create(:user=>@user, :name=>'project1', :review_interval=>7)
      p1.reviewed_at.should be_nil
      p1.next_review.should be_nil
      Time.advance(1.day)
      p1.record_review
      p1.save!

      p1.reviewed_at.should == Time.parse("2007 1/2")
      p1.next_review.should == Time.parse("2007 1/9")
    end
  end

  it "can be locked for protect deletion" do
    prj = Project.create(:user=>@user, :name=>'project1', :locked=>true)
    proc { prj.destroy }.should raise_error(Project::LockedError)
    prj.locked = false
    prj.save
    prj.destroy


    prj = Project.create(:user=>@user, :name=>'project1')
    prj.locked = true
    prj.save
    proc { prj.destroy }.should raise_error(Project::LockedError)
    prj.locked = false
    prj.save
    prj.destroy
  end

  it "is locked if it is root" do
    proc { @user.root_project.destroy }.should raise_error(Project::LockedError)
  end

  it "can produce project tree" do
    root = @user.root_project
    root.tree.should == [[0, root]]
    p1 = root.sub_projects.create(:name=>'aaa')
    p2 = root.sub_projects.create(:name=>'bbb')
    root.tree.should == [
                         [0, root],
                         [1, p1],
                         [1, p2]
                        ]
    p3 = p1.sub_projects.create(:name=>'ccc')
    p4 = p3.sub_projects.create(:name=>'ddd')
    root.tree.should == [
                         [0, root],
                         [1, p1],
                         [2, p3],
                         [3, p4],
                         [1, p2]
                        ]

  end
end
