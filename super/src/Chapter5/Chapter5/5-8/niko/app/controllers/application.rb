# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

require 'login_engine'

class ApplicationController < ActionController::Base
  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_niko_session_id'

  include LoginEngine
  helper :user
  model :user
  before_filter :login_required
  
end
