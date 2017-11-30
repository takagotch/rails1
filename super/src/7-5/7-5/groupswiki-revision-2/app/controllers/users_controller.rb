class UsersController < ApplicationController
  layout 'app'
  
  def show
    @user = User.find_by_name params[:id]
    @pages = current_wiki.revisions.find(
      :all,
      :conditions => ['user_id=?', @user.id],
      :order => 'ID desc',
      :limit => 10
    )
  end
  
end
