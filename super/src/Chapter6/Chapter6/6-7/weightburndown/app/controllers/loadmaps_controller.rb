class LoadmapsController < ApplicationController
  def index
    redirect_to :controller => 'weightburndown' , :action => 'index'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :create, :update ],
         :redirect_to => { :controller => 'weightburndown',:action => :index }
  
  def list
    @loadmap_pages, @loadmaps = paginate :loadmaps, :per_page => 10
  end
  

  def new
    @loadmap = Loadmap.new
  end

  def create
    @loadmap = Loadmap.new(params[:loadmap])
    #開始日に今日の日付をセットする
    @loadmap.start_date = Date.today
    if @loadmap.save
      flash[:notice] = 'ロードマップを作成しました！がんばろう！'
      redirect_to :controller => 'weightburndown',:action => 'index'
    else
      render :action => 'new'
    end
  end
  
  def edit
    @loadmap = Loadmap.find(params[:id])
  end

  def update
    @loadmap = Loadmap.find(params[:id])
    if @loadmap.update_attributes(params[:loadmap])
      flash[:notice] = 'ロードマップを変更しました！'
      redirect_to :controller => 'weightburndown',:action => 'index'
    else
      render :action => 'edit'
    end
  end
end
