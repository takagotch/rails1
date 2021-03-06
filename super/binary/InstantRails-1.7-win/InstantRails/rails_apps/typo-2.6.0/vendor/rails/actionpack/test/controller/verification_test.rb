require File.dirname(__FILE__) + '/../abstract_unit'

class VerificationTest < Test::Unit::TestCase
  class TestController < ActionController::Base
    verify :only => :guarded_one, :params => "one",
           :redirect_to => { :action => "unguarded" }

    verify :only => :guarded_two, :params => %w( one two ),
           :redirect_to => { :action => "unguarded" }

    verify :only => :guarded_with_flash, :params => "one",
           :add_flash => { "notice" => "prereqs failed" },
           :redirect_to => { :action => "unguarded" }

    verify :only => :guarded_in_session, :session => "one",
           :redirect_to => { :action => "unguarded" }

    verify :only => [:multi_one, :multi_two], :session => %w( one two ),
           :redirect_to => { :action => "unguarded" }

    verify :only => :guarded_by_method, :method => :post,
           :redirect_to => { :action => "unguarded" }
           
    verify :only => :guarded_by_xhr, :xhr => true,
           :redirect_to => { :action => "unguarded" }
           
    verify :only => :guarded_by_not_xhr, :xhr => false,
           :redirect_to => { :action => "unguarded" }

    before_filter :unconditional_redirect, :only => :two_redirects
    verify :only => :two_redirects, :method => :post,
           :redirect_to => { :action => "unguarded" }

    verify :only => :must_be_post, :method => :post, :render => { :status => 500, :text => "Must be post"}

    def guarded_one
      render :text => "#{@params["one"]}"
    end

    def guarded_with_flash
      render :text => "#{@params["one"]}"
    end

    def guarded_two
      render :text => "#{@params["one"]}:#{@params["two"]}"
    end

    def guarded_in_session
      render :text => "#{@session["one"]}"
    end

    def multi_one
      render :text => "#{@session["one"]}:#{@session["two"]}"
    end

    def multi_two
      render :text => "#{@session["two"]}:#{@session["one"]}"
    end

    def guarded_by_method
      render :text => "#{@request.method}"
    end
    
    def guarded_by_xhr
      render :text => "#{@request.xhr?}"
    end
    
    def guarded_by_not_xhr
      render :text => "#{@request.xhr?}"
    end

    def unguarded
      render :text => "#{@params["one"]}"
    end

    def two_redirects
      render :nothing => true
    end
    
    def must_be_post
      render :text => "Was a post!"
    end
    
    protected
      def rescue_action(e) raise end

      def unconditional_redirect
        redirect_to :action => "unguarded"
      end
  end

  def setup
    @controller = TestController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_guarded_one_with_prereqs
    get :guarded_one, :one => "here"
    assert_equal "here", @response.body
  end

  def test_guarded_one_without_prereqs
    get :guarded_one
    assert_redirected_to :action => "unguarded"
  end

  def test_guarded_with_flash_with_prereqs
    get :guarded_with_flash, :one => "here"
    assert_equal "here", @response.body
    assert_flash_empty
  end

  def test_guarded_with_flash_without_prereqs
    get :guarded_with_flash
    assert_redirected_to :action => "unguarded"
    assert_flash_equal "prereqs failed", "notice"
  end

  def test_guarded_two_with_prereqs
    get :guarded_two, :one => "here", :two => "there"
    assert_equal "here:there", @response.body
  end

  def test_guarded_two_without_prereqs_one
    get :guarded_two, :two => "there"
    assert_redirected_to :action => "unguarded"
  end

  def test_guarded_two_without_prereqs_two
    get :guarded_two, :one => "here"
    assert_redirected_to :action => "unguarded"
  end

  def test_guarded_two_without_prereqs_both
    get :guarded_two
    assert_redirected_to :action => "unguarded"
  end

  def test_unguarded_with_params
    get :unguarded, :one => "here"
    assert_equal "here", @response.body
  end

  def test_unguarded_without_params
    get :unguarded
    assert_equal "", @response.body
  end

  def test_guarded_in_session_with_prereqs
    get :guarded_in_session, {}, "one" => "here"
    assert_equal "here", @response.body
  end

  def test_guarded_in_session_without_prereqs
    get :guarded_in_session
    assert_redirected_to :action => "unguarded"
  end

  def test_multi_one_with_prereqs
    get :multi_one, {}, "one" => "here", "two" => "there"
    assert_equal "here:there", @response.body
  end

  def test_multi_one_without_prereqs
    get :multi_one
    assert_redirected_to :action => "unguarded"
  end

  def test_multi_two_with_prereqs
    get :multi_two, {}, "one" => "here", "two" => "there"
    assert_equal "there:here", @response.body
  end

  def test_multi_two_without_prereqs
    get :multi_two
    assert_redirected_to :action => "unguarded"
  end

  def test_guarded_by_method_with_prereqs
    post :guarded_by_method
    assert_equal "post", @response.body
  end

  def test_guarded_by_method_without_prereqs
    get :guarded_by_method
    assert_redirected_to :action => "unguarded"
  end
  
  def test_guarded_by_xhr_with_prereqs
    xhr :post, :guarded_by_xhr
    assert_equal "true", @response.body
  end
    
  def test_guarded_by_xhr_without_prereqs
    get :guarded_by_xhr
    assert_redirected_to :action => "unguarded"
  end
  
  def test_guarded_by_not_xhr_with_prereqs
    get :guarded_by_not_xhr
    assert_equal "false", @response.body
  end
    
  def test_guarded_by_not_xhr_without_prereqs
    xhr :post, :guarded_by_not_xhr
    assert_redirected_to :action => "unguarded"
  end
  
  def test_guarded_post_and_calls_render    
    post :must_be_post
    assert_equal "Was a post!", @response.body
    
    get :must_be_post
    assert_response 500
    assert_equal "Must be post", @response.body
  end
  

  def test_second_redirect
    assert_nothing_raised { get :two_redirects }
  end
end
