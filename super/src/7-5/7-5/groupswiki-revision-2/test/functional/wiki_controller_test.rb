require File.dirname(__FILE__) + '/../test_helper'
require 'wikis_controller'

# Re-raise errors caught by the controller.
class WikisController; def rescue_action(e) raise e end; end

class WikisControllerTest < Test::Unit::TestCase
  use_all_fixtures
  
  def setup
    @controller = WikisController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @request.host = 'localhost'

    login :ben
  end
  
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_edit
    get :edit
    assert_template 'edit'
  end
  
  def test_update
    post :update, :wiki => {:anyone_write => '0'}
    assert_equal false, assigns(:wiki).anyone_write?
    assert_template 'edit'
  end
  
  def test_no_edit
    login :andrew

    assert_raises(ActiveRecord::RecordNotFound) do
      get :edit
    end
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create
    post :create, :wiki => {:domain => 'zing', :email => 'bnolan@gmail.com'}
    assert_redirected_to 'http://zing.groupswiki.com/'

    assert Wiki.find_by_domain('zing.groupswiki.com')
    assert_equal 'bnolan@gmail.com', Wiki.find_by_domain('zing.groupswiki.com').email
  end
    
end
