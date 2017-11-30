class ConditionsController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  def list
  end
end
