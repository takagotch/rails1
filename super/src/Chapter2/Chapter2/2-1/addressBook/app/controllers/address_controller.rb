class AddressController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @address_pages, @addresses = paginate :addresses, :per_page => 10
  end

  def show
    #@address = Address.find(params[:id]) #//コメントアウト
    @address = Address.find(params[:id],:include => [:userDetail,:mails]) #//:includeオプションを追加
    @userDetail = @address.userDetail #//user_detailsテーブルからデータを取得する処理を追加
    @mails = @address.mails #//mailsテーブルからデータを取得する処理を追加
  end

  def new
    @address = Address.new
  end

  def create
    @address = Address.new(params[:address])
    @userDetail = UserDetail.new(params[:userDetail]) #//user_detailsテーブルの追加処理を追加
    @address.userDetail = @userDetail                 #//
    if @address.save
      flash[:notice] = 'Address was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    #@address = Address.find(params[:id]) #//コメントアウト
    if (session[:address] != nil)         #//以下を追加
        userId = session[:address]
    else
        userId = params[:id]
    end

    @address = Address.find(userId)
    @userDetail = @address.userDetail
    @mails = @address.mails
    @mail = @mails[0]
    session[:address] = nil              #//追加ここまで
  end

  def update
#    @address = Address.find(params[:id])   #//以下をコメントアウト
#    if @address.update_attributes(params[:address])
#      flash[:notice] = 'Address was successfully updated.'
#      redirect_to :action => 'show', :id => @address
#    else
#      render :action => 'edit'
#    end                                   #//コメントアウトここまで

    @address = Address.find(params[:id])   #//以下を追加
    @userDetail = @address.userDetail
    if (@userDetail == nil) 
        @userDetail = UserDetail.new(params[:userDetail])
        @address.userDetail = @userDetail
    else 
        @userDetail.update_attributes(params[:userDetail])
    end
    if @address.update_attributes(params[:address]) 
      flash[:notice] = 'Address was successfully updated.'
      redirect_to :action => 'show', :id => @address
    else 
      render :action => 'edit'
    end                                     #//追加ここまで
  end

  def destroy
    Address.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end