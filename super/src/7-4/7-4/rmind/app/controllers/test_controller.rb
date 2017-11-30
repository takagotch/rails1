class TestController < ApplicationController
  before_filter :authorize
  around_filter :with_users_scope

  def index
  end
end
