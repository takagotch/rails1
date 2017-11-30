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

  # セルにアイコンをドロップされたとき呼び出される処理
  def cell_update
    @condition = Condition.find(:first,
      :conditions=> ["user_id=:user_id and date=:date", params])
    if params[:id] == 'blank'
      # blankをドロップされときは、データを削除します
      clear
    elsif @condition
      # blankではないセルのときはデータを更新します
      update
    else
      # blankのセルのときは新しく作成します
      create
    end
  end

  def clear
    # 登録データがあれば、削除します
    if @condition
      Condition.find(@condition.id).destroy
    end
    # セルの表示をblankアイコンで更新します（conditionがない状態にします）
    render :partial => 'cell',
      :locals => { :user_id =>params[:user_id], :cond =>nil, :date =>params[:date] }
  end

  def create
    # 登録データがないので、パラメータに従って新規に作成、保存します
    @condition = Condition.new(
      :user_id=>params[:user_id], :date=>params[:date], :name=>params[:id] )
    if @condition.save
      flash[:notice] = 'Condition was successfully created.'
      # セルの表示を作成したデータに対応するアイコンで更新します
      render :partial => 'cell',
        :locals => { :user_id =>params[:user_id], :cond =>@condition, :date =>params[:date] }
    else
      # 保存に失敗したときはエラーメッセージを表示します
      flash[:notice] = "Condition creation was failed."
      render :inline => %{<p>Creation Failed</p> <%= debug(@params) %>}
    end
  end
  
  def update
    # 登録データがあったので、パラメータに従ってデータを更新します
    if @condition.update_attributes(:name=>params[:id])
      flash[:notice] = 'Condition was successfully updated.'
      # セルの表示を更新したデータに対応するアイコンで更新します
      render :partial => 'cell',
        :locals => { :user_id =>params[:user_id], :cond =>@condition, :date =>params[:date] }
    else
      # 更新に失敗したときはエラーメッセージを表示します
      flash[:notice] = "Condition update was failed."
      render :inline => %{<p>Update Failed</p> <%= debug(@params) %>}
    end
  end
  
  private :clear, :create, :update

end
