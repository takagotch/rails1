# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  include ExceptionNotifiable
  before_filter :current_wiki

  def is_production?
    PRODUCTION_BOX
  end
  helper_method :is_production?

  protected
  
  def current_wiki
    @current_wiki ||= Wiki.find_by_domain(host_name)
  end
  helper_method :current_wiki

  def host_name
    PRODUCTION_BOX ? request.host : 'localhost'
  end

  def serialize_request
    {
      :uri => request.request_uri,
      :params => params,
      :method => request.post? ? :post : :get
    }
  end
end