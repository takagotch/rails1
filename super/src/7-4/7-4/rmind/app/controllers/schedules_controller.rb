
class SchedulesController < ApplicationController
  before_filter :authorize

  around_filter :with_users_scope

  def timeline
    @need_timeline = true
    @schedules = @user.schedules
  end

  def schedules
    @schedules = @user.schedules
    response.content_type = Mime::XML
    render :partial=>'schedules'
  end
end
