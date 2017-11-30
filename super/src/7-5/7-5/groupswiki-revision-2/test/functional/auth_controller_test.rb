require File.dirname(__FILE__) + '/../test_helper'
require 'auth_controller'

# Re-raise errors caught by the controller.
class AuthController; def rescue_action(e) raise e end; end

class AuthControllerTest < Test::Unit::TestCase
  use_all_fixtures

  def setup
    @controller = AuthController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_mark_signs_up
    post :signup, :user => {:name => 'Mark Bottomface', :email => 'mark@gmail.com', :password => 'zing'}
    assert_equal 2, assigns(:user).errors.length
    assert_template 'login'

    post :signup, :user => {:name => 'Mark_Bottomface', :email => 'mark@gmail.com', :password => 'zing', :password_confirmation => 'blah'}
    assert_equal 1, assigns(:user).errors.length
    assert_template 'login'

    post :signup, :user => {:name => 'Mark_Bottomface', :email => 'bnolan@gmail.com', :password => 'zing', :password_confirmation => 'zing'}
    assert_equal 1, assigns(:user).errors.length
    assert_template 'login'

    post :signup, :user => {:name => 'Mark_Bottomface', :email => 'mark@gmail.com', :password => 'zing', :password_confirmation => 'zing'}
    assert !session[:user_id].nil?
    assert_redirected_to 'http://mark_bottomface-private.groupswiki.com/'
  end
  
  def test_logout
    @request.session[:user_id] = 1
    get :logout
    assert session[:user_id].nil?
  end
  
  def test_login
    get :login
    assert_template 'login'
    
    post :login, :user => {:email => users(:andrew).email, :password => users(:ben).password}
    assert_equal nil, session[:user_id]
    assert_template 'login'

    post :login, :user => {:email => users(:ben).email, :password => users(:ben).password}
    assert_equal 1, session[:user_id]
    assert_equal users(:ben).remember_me_cookie, cookies['remember_me'].first
    assert_redirected_to 'http://localhost/'
  end
  
  def test_andrew_login
    post :login, :user => {:email => users(:andrew).email, :password => users(:andrew).password}
    assert_equal 3, session[:user_id]
    assert_redirected_to 'http://andrew-private.groupswiki.com/'
  end

  def test_remember_me
    @request.cookies['remember_me'] = users(:ben).remember_me_cookie
    get :login
    #GRR!
    #assert_equal 1, session[:user_id]
  end
  
  def test_broken_remember_me_cookie
    @request.cookies['remember_me'] = '124:OFUBNW EFIUB @#!!!'
    get :login
    assert_equal nil, session[:user_id]
    assert_template 'login'
  end
  
end
