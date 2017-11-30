require File.dirname(__FILE__) + '/../spec_helper'
require 'spec/common'

describe ExportController do
  it_should_behave_like "TestWithOneUser"

  #Delete these examples and add some real ones
  it "should use ExportController" do
    controller.should be_an_instance_of(ExportController)
  end

  it "reject access index without login" do
    get 'index'
    response.should redirect_to(:controller=>:user, :action => :login)
  end

  it "reject access show without login" do
    get 'show'
    response.should redirect_to(:controller=>:user, :action => :login)
  end

  it "GET 'index' should be successful" do
    login
    get 'index'
    response.should be_success
    assigns(:export_tags).should == []
  end

  it "GET 'show' should be successful" do
    login
    ExportTag.create(:name=>'aaa', :user=>@user)
    get 'index'
    response.should be_success
    assigns(:export_tags).size.should == 1
    assigns(:export_tags).first.name.should == 'aaa'
  end

  it "POST 'new' should be successful" do
    login
    post 'new', :tag => { :name=>'aaa'}
    response.should redirect_to(:action => :index)
    #response.should be_success
    tag = assigns(:export_tag)
    tag.name.should == 'aaa'
    tag.private_key.key.should_not be_nil
    tag.private_key.key.size.should == 32
  end

  it "can export ical" do
    tag = ExportTag.create(:name=>'export', :user=>@user)
    task = Task.create(:text=>'xyz', :user=>@user)
    task.tag = "080119 export"
    task.save!
    get 'ical', :id=>tag.private_key.key
    response.should be_success
    schedules = assigns(:schedules)
    schedules.size.should == 1
    sch = schedules.first
    sch.uid.should_not be_nil
    sch.dtstart.should == "20080119"
    sch.dtend.should == "20080119"
  end

  it "can export ical with only ExportTag" do
    tag1 = ExportTag.create(:name=>'export1', :user=>@user)
    tag2 = ExportTag.create(:name=>'export2', :user=>@user)
    task = Task.create(:text=>'xyz', :user=>@user)

    task.tag = "080119 export"
    task.save!
    get 'ical', :id=>tag1.private_key.key
    response.should be_success
    schedules = assigns(:schedules)
    schedules.size.should == 0

    task.tag = "export1"
    task.save!
    get 'ical', :id=>tag1.private_key.key
    response.should be_success
    schedules = assigns(:schedules)
    schedules.size.should == 0

    task.tag = "080119 export1"
    task.load_tagging_value
    task.tagging_value["080119"][:from] = "13:00"
    task.save!

    get 'ical', :id=>tag2.private_key.key
    response.should be_success
    schedules = assigns(:schedules)
    schedules.size.should == 0

    get 'ical', :id=>tag1.private_key.key
    response.should be_success
    schedules = assigns(:schedules)
    schedules.size.should == 1
    sch = schedules.first
    sch.uid.should_not be_nil
    sch.dtstart.should == "20080119T130000"
    sch.dtend.should == "20080119T130000"

    task.tag = "080119 export2"
    task.load_tagging_value
    task.tagging_value["080119"][:from] = "13:00"
    task.tagging_value["080119"][:to] = "15:00"
    task.save!

    get 'ical', :id=>tag1.private_key.key
    response.should be_success
    schedules = assigns(:schedules)
    schedules.size.should == 0

    get 'ical', :id=>tag2.private_key.key
    response.should be_success
    schedules = assigns(:schedules)
    schedules.size.should == 1
    sch = schedules.first
    sch.uid.should_not be_nil
    sch.dtstart.should == "20080119T130000"
    sch.dtend.should == "20080119T150000"
end
end
