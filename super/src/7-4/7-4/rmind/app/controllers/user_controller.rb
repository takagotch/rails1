class UserController < ApplicationController
  TEMPLATE="user_template/standard_ja.yml"
  before_filter :authorize, :except=>[:login, :signup]

  def login
    if request.method == :post
      u = User.authenticate(params[:user][:login], params[:user][:password])
      session[:user_id] = u.id
      flash[:notice] = _('Login successful')
      redirect_to :controller=>'main', :action=>'index'
    end
  rescue User::AuthenticationError
    session[:user_id] = nil
    flash[:warning] = _('Login unsuccessful')
  end

  def signup
    u = nil
    if request.method != :post
      @user = User.new
    else
      #u = User.create(params[:user])
      #u.initial_setup

      if params[:user][:password].blank?
        @user = User.new(params[:user])
        flash[:error] = "enter password"
        return
      end

      u = User::load_yaml(File::open(TEMPLATE), params[:user][:login])
      u.update_attributes!(params[:user])
      session[:user_id] = u.id
      flash[:notice] = _('Signup successful')
      redirect_to :action=>'login'
    end
  rescue ActiveRecord::RecordInvalid
    u.destroy if u
    @user = User.new(params[:user])
    flash[:error] = $!.to_s
  rescue
    u.destroy if u
    raise
  end

  def edit
    u = User.find(session[:user_id])

    if request.method == :post
      u.update_attributes!(params[:user])
    end

  rescue ActiveRecord::RecordInvalid
    flash[:error] = $!.to_s
  end

  def delete
    u = User.find(session[:user_id])

    u.root_project.locked = false
    u.root_project.save!
    u.destroy
    redirect_to :action=>'login'
  end

  def setting
  end

  def logout
    session[:user_id] = nil
    flash[:notice] = _('Logouted')
    redirect_to :action=>:login
  end

  def export
    send_data @user.to_yaml
  end
end
