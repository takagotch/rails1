class UserMailController < ApplicationController
  def index
    list
    render :action => 'userMailList'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def userMailList
    if (session[:address] != nil) 
        addressId = session[:address]
    else
        addressId = params[:id]
    end
    @mails = Mail.find(:all, :conditions =>["address_id = ?",addressId])
    session[:address] = addressId
  end

  def newUserMail
    @mail = Mail.new
  end

  def create
    @mail = Mail.new(params[:mail])
    @address = Address.find(session[:address])
    @address.mails << @mail
    if @mail.save
      flash[:notice] = 'Mail was successfully created.'
      redirect_to :action => 'userMailList'
    else
      render :action => 'newUserMail'
    end
  end

  def editUserMail
    @mail = Mail.find(params[:id])
  end

  def update
    @mail = Mail.find(params[:id])
    if @mail.update_attributes(params[:mail])
      flash[:notice] = 'Mail was successfully updated.'
      redirect_to :action => 'userMailList'
    else
      render :action => 'editUserMail'
    end
  end

  def destroy
    Mail.find(params[:id]).destroy
    redirect_to :action => 'userMailList'
  end
end
