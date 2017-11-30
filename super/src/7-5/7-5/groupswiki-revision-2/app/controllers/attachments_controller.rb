class AttachmentsController < ApplicationController

  def new
    render :partial => 'create'
  end
  
  def create
    if params[:attachment]
      @attachment = Attachment.create params[:attachment]

      if @attachment
        render :action => 'insert'
      else
        render :action => 'error'
      end

      return
    end
    
    render :update do |page|
      page.replace_html 'lightbox-dialog', :partial=>'create'
    end
  end
  
end
