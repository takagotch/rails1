class User < ActiveRecord::Base
  include LoginEngine::AuthenticatedUser
  #Userは複数のTranscriptを所有する
  has_many :transcripts

  # all logic has been moved into login_engine/lib/login_engine/authenticated_user.rb

end

