require File.dirname(__FILE__) + '/../test_helper'
require 'dailyweights_controller'

# Re-raise errors caught by the controller.
class DailyweightsController; def rescue_action(e) raise e end; end

class DailyweightsControllerTest < Test::Unit::TestCase
  fixtures :dailyweights

  def setup
    @controller = DailyweightsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = dailyweights(:first).id
  end

  def test_index
    get :index
    assert_response :success
    assert_template 'list'
  end

  def test_list
    get :list

    assert_response :success
    assert_template 'list'

    assert_not_nil assigns(:dailyweights)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:dailyweight)
    assert assigns(:dailyweight).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:dailyweight)
  end

  def test_create
    num_dailyweights = Dailyweight.count

    post :create, :dailyweight => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_dailyweights + 1, Dailyweight.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:dailyweight)
    assert assigns(:dailyweight).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Dailyweight.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Dailyweight.find(@first_id)
    }
  end
end
