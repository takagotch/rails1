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
    #@address = Address.find(params[:id]) #//�R�����g�A�E�g
    @address = Address.find(params[:id],:include => [:userDetail,:mails]) #//:include�I�v�V������ǉ�
    @userDetail = @address.userDetail #//user_details�e�[�u������f�[�^���擾���鏈����ǉ�
    @mails = @address.mails #//mails�e�[�u������f�[�^���擾���鏈����ǉ�
  end

  def new
    @address = Address.new
  end

  def create
    @address = Address.new(params[:address])
    @userDetail = UserDetail.new(params[:userDetail]) #//user_details�e�[�u���̒ǉ�������ǉ�
    @address.userDetail = @userDetail                 #//
    if @address.save
      flash[:notice] = 'Address was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    #@address = Address.find(params[:id]) #//�R�����g�A�E�g
    if (session[:address] != nil)         #//�ȉ���ǉ�
        userId = session[:address]
    else
        userId = params[:id]
    end

    @address = Address.find(userId)
    @userDetail = @address.userDetail
    @mails = @address.mails
    @mail = @mails[0]
    session[:address] = nil              #//�ǉ������܂�
  end

  def update
#    @address = Address.find(params[:id])   #//�ȉ����R�����g�A�E�g
#    if @address.update_attributes(params[:address])
#      flash[:notice] = 'Address was successfully updated.'
#      redirect_to :action => 'show', :id => @address
#    else
#      render :action => 'edit'
#    end                                   #//�R�����g�A�E�g�����܂�

    @address = Address.find(params[:id])   #//�ȉ���ǉ�
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
    end                                     #//�ǉ������܂�
  end

  def destroy
    Address.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end