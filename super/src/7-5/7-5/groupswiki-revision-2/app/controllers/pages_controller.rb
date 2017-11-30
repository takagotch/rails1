class PagesController < ApplicationController
  layout 'app'
  
  def homepage
    redirect_to current_wiki.index_page
  end

  def index
    conditions = if params[:q] 
      @query= params[:q]
      sql_query = "%#{params[:q]}%"
      ['(name LIKE ? OR content LIKE ?)', sql_query, sql_query]
    else
      '1=1'
    end

    @pages = current_wiki.pages.find(
      :all,
      :conditions => conditions
    )

    respond_to do |wants|
      wants.html {render :action => 'index'}
      wants.xml {render :xml => @pages.to_xml(:except => [:content])}
    end
  end

  def revisions
    @page = current_wiki.pages.find_by_path params[:id]
  end
  
  #   render :update do |page|
  #     page['search-results'].show();
  #     page['search-results'].replace_html :partial => 'search_results', :locals => {:pages => pages, :query => query}
  #   end
  # end
  # 

  def revert
    page = current_wiki.pages.find_by_path params[:id]
    page.revert_to params[:version].to_i+1
    page.save
    
    flash[:message] = "Reverted back to version #" + params[:version].to_i.to_s
    redirect_to page_url(page)
  end

  # def delete
  #   page = @client.pages.find_by_name params[:name]
  #   page.destroy
  #   
  #   redirect_to :action=>'show', :wiki=>params[:wiki]
  # end

  def show
    @page = current_wiki.pages.find_by_path(params[:id])

    if @page.nil?
      @page = current_wiki.create_blank_page(params[:id])
    end
    
    if @page.content.blank?
      @mode = :edit
    end
    
    respond_to do |wants|
      wants.html
      wants.xml {render :xml => @page.to_xml}
    end
  end

  def edit
    @page = current_wiki.pages.find_by_path(params[:id])

    if @page.nil?
      @page = current_wiki.create_blank_page(params[:id])
    end

    @mode = :edit
    render :action => 'show'
  end

  def update
    page = current_wiki.pages.find_by_path(params[:id])
    
    if page.nil?
      raise ActiveRecord::RecordNotFound
    end
    
    page.attributes = params[:page]
    page.save!

    if request.xhr?
      render :text=>'ok'
    else
      redirect_to :back
    end
  end
end
