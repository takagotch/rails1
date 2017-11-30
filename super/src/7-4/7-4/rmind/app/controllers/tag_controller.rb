class TagController < ApplicationController
  before_filter :authorize
  around_filter :with_users_scope

  def index
    @tags = Hash.new do |h, k|
      h[k] = []
    end
    @user.tags.find(:all).each do |t|
      @tags[t.class.name.intern] << t
    end
  end

  def show
    @the_tag = Tag.find(params[:id])
    q = Task.query.trashed_at_is_null
    q.user_id_eq(@the_tag.user.id)
    q.join("taggings").tag_id_eq(@the_tag.id)
    @tasks = q.find(:all, :order=>'updated_at')
  end
end
