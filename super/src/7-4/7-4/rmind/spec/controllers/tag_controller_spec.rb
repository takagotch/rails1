require File.dirname(__FILE__) + '/../spec_helper'

describe TagController do

  #Delete these examples and add some real ones
  it "should use TagController" do
    controller.should be_an_instance_of(TagController)
  end


  it "GET 'index' should be successful" do
    get 'index'
    response.should redirect_to(:controller=>:user, :action => :login)
  end

  it "GET 'show' should be successful" do
    get 'show'
    response.should redirect_to(:controller=>:user, :action => :login)
  end
end
