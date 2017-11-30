# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  init_gettext "login_engine"
  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_rmind_session_id'

  #GetText.locale = "ja"
  init_gettext "rmind"

  def authorize
    user_id = session[:user_id]
    unless user_id and not (@user = User.find(user_id)).nil?
      redirect_to :action=>:login, :controller=>:user
      false
    end
  rescue ActiveRecord::RecordNotFound
    session[:user_id] = nil
    redirect_to :action=>:login, :controller=>:user
    false
  end

  def with_users_scope
    @user.with_myscope do
      yield
    end
  end

  def record_url(url)
    session[:last_url] = url
  end

  def redirect_back
    if session[:last_url]
      redirect_to session[:last_url]
    else
      redirect_to :action=>:index, :controller=>:main
    end
  end

end
