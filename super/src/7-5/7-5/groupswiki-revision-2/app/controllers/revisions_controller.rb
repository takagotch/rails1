class RevisionsController < ApplicationController
  layout 'app'

  def index
    @pages, @revisions = paginate(
      :revisions, :conditions => ['wiki_id=?', current_wiki.id], :order => 'ID desc', :per_page => 50
    )
  end

end
