class DailyweightsController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @dailyweight_pages, @dailyweights = paginate :dailyweights, :per_page => 10
  end

  def new
    @dailyweight = Dailyweight.new
    
    #記録忘れの場合
    @dailyweight.submit_date=params[:submit_date]  unless params[:submit_date].blank?
    
  end

  def create
    @dailyweight = Dailyweight.new(params[:dailyweight])

    if params[:dailyweight][:submit_date].blank?
      @dailyweight.submit_date = Date.today
    else
      #記録忘れの場合
      @dailyweight.submit_date = params[:dailyweight][:submit_date]
    end
    
    if @dailyweight.save
      flash[:notice] = '体重を記録しました！'
      redirect_to :controller => 'weightburndown',:action => 'index'
    else
      render :action => 'new'
    end
  end


  def edit
    @dailyweight = Dailyweight.find(params[:id])
  end

  def update
    @dailyweight = Dailyweight.find(params[:id])
    if @dailyweight.update_attributes(params[:dailyweight])
      flash[:notice] = '体重を修正しました！'
      redirect_to :controller => 'weightburndown',:action => 'index'
    else
      render :action => 'edit'
    end
  end

  def review
    @dailyweight = Dailyweight.find(params[:id])
  end
end
