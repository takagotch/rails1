require File.dirname(__FILE__) + '/../test_helper'
require 'pages_controller'

# Re-raise errors caught by the controller.
class PagesController; def rescue_action(e) raise e end; end

class PagesControllerTest < Test::Unit::TestCase
  use_all_fixtures
  
  def setup
    @controller = PagesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request
    login :ben
    @request.env["HTTP_REFERER"] = "/example"
  end
  
  def test_index
    get :index
    assert_template 'index'
    assert_equal 3, assigns(:pages).length
  end

  def test_search
    get :index, :q => 'welcome'
    assert_template 'index'
    assert_equal 1, assigns(:pages).length
  end

  def test_show
    get :show, :id => pages(:index).to_param
    assert_template 'show'
  end

  def test_show_new
    get :show, :id => 'new_page'
    assert_template 'show'
    assert assigns(:page)
    assert_equal nil, assigns(:page).content
    assert_equal 'New page', assigns(:page).name
    assert !assigns(:page).new_record?
    assert assigns(:page).id
  end

  def test_update
    post :update, :id => pages(:index).to_param, :page => {:content => 'zing!'}
    assert_redirected_to '/example'
    assert_equal 'zing!', pages(:index).reload.content
  end
  
  def test_update_new_page
    assert_raises(ActiveRecord::RecordNotFound) do
      post :update, :id => 'blahzah', :page => {:content => '<p>zoozing!</p>'}
    end
    
    #assert_redirected_to '/example'
    #assert_equal '<p>zoozing!</p>', Page.find_by_path('blahzah').content
  end
  
end
