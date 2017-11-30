class User < ActiveRecord::Base
  include LoginEngine::AuthenticatedUser

  has_many :conditions

  # all logic has been moved into login_engine/lib/login_engine/authenticated_user.rb

end
