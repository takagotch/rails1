require File.dirname(__FILE__) + '/../test_helper'
require 'revisions_controller'

# Re-raise errors caught by the controller.
class RevisionsController; def rescue_action(e) raise e end; end

class RevisionsControllerTest < Test::Unit::TestCase
  use_all_fixtures
  
  def setup
    @controller = RevisionsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_index
    get :index
    assert_template 'index'
    assert_equal 3, assigns(:revisions).length
  end  

end
