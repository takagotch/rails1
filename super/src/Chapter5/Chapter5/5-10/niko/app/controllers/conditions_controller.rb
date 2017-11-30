class ConditionsController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  def list
  end

  def new
    @condition = Condition.new
  end

  def create
    @condition = Condition.new(params[:condition])
    if @condition.save
      flash[:notice] = 'Condition was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

end
