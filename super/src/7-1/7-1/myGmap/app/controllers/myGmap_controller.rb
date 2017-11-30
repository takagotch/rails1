class MygmapController < ApplicationController
  def index
    myGmap
    render :action => 'myGmap'
  end

  def myGmap
  
    @lat=params[:lat].to_f
    @lng=params[:lng].to_f

    @lat=35.681099 if params[:lat].blank?
    @lng=139.767084 if params[:lng].blank?
     
  end
end
