class WikisController < ApplicationController
  require 'zip/zip'

  layout 'app'
  before_filter :require_authentication, :only => [:layout, :users, :edit]

  def new
    @wiki = Wiki.new
  end
  
  def create
    @wiki = Wiki.new(params[:wiki])
    
    if @wiki.save
      Notifier.deliver_signup_thanks(@wiki)
      redirect_to 'http://' + @wiki.domain + '/'
    else
      render :action => 'new'
    end
  end
  
  def edit
    @wiki = current_wiki
    
    if not current_user.owned_wikis.include? @wiki
      raise ActiveRecord::RecordNotFound
    end
  end
  
  def update
    @wiki = current_wiki
    
    if not current_user.owned_wikis.include? @wiki
      raise ActiveRecord::RecordNotFound
    end
    
    @wiki.update_attributes! params[:wiki]
    flash[:message] = "Wiki settings updated"
    
    render :action =>'edit'
  end
  
  def export
    export_pages_as_zip('html') do |page| 
      rendered_page = <<-EOL
        <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
        <html xmlns="http://www.w3.org/1999/xhtml">
        <head>
          <title>#{page.name} in #{current_wiki.name}</title>
          <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        </head>
        <body>
          <h1>
            #{page.name}
          </h1>
          
          #{page.content}
        </body>
        </html>
      EOL
      rendered_page
    end
  end

  def export_pages_as_zip(file_type, &block)
    filename = "#{current_wiki.domain}.#{file_type}"
    #timestamp = Time.now #current_wiki.revised_at.strftime('%Y-%m-%d-%H-%M-%S')
    file_path = '/tmp/' + filename
    #tmp_path = "#{file_path}.tmp"

    Zip::ZipOutputStream.open(file_path) do |zip_out|
      current_wiki.pages.each do |page|
        zip_out.put_next_entry("#{CGI.escape(page.path)}.#{file_type}")
        zip_out.puts(block.call(page))
      end
      # add an index file, if exporting to HTML
      #if file_type.to_s.downcase == 'html'
        #zip_out.put_next_entry 'index.html'
        #zip_out.puts "<html><head>" +
        #    "<META HTTP-EQUIV=\"Refresh\" CONTENT=\"0;URL=HomePage.#{file_type}\"></head></html>"
      #end
    end
    #FileUtils.rm_rf(Dir[File.join(@wiki.storage_path, file_prefix + '*.zip')])
    #FileUtils.mv(tmp_path, file_path)
    send_file file_path
  end

  def layout
    if request.post?
      current_wiki.update_attributes! params[:wiki]
      flash[:message] = "Changes saved. Refresh your page to view the changes"
    end
  end

  def users
    if request.post?
      current_wiki.update_attributes! params[:wiki]
      flash[:message] = "Changes saved. Refresh your page to view the changes"
    end
  end
    
  # def update
  #   if current_user.can_edit? current_wiki
  #     current_wiki.attributes = params[:wiki]
  #     
  #     if current_wiki.save
  #       redirect_to edit_wiki_url(current_wiki)
  #     else
  #       render :action => 'edit'
  #     end
  #   end
  # end
  # 
  # def new
  # end
  
  # def create
  #   @wiki = current_user.owned_wikis.build params[:wiki]
  #   
  #   if @wiki.save
  #     render :action => 'created'
  #   else
  #     render :action => 'new'
  #   end
  # end
end
