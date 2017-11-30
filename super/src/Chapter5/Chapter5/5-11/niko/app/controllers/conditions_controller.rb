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

  # �Z���ɃA�C�R�����h���b�v���ꂽ�Ƃ��Ăяo����鏈��
  def cell_update
    @condition = Condition.find(:first,
      :conditions=> ["user_id=:user_id and date=:date", params])
    if params[:id] == 'blank'
      # blank���h���b�v����Ƃ��́A�f�[�^���폜���܂�
      clear
    elsif @condition
      # blank�ł͂Ȃ��Z���̂Ƃ��̓f�[�^���X�V���܂�
      update
    else
      # blank�̃Z���̂Ƃ��͐V�����쐬���܂�
      create
    end
  end

  def clear
    # �o�^�f�[�^������΁A�폜���܂�
    if @condition
      Condition.find(@condition.id).destroy
    end
    # �Z���̕\����blank�A�C�R���ōX�V���܂��icondition���Ȃ���Ԃɂ��܂��j
    render :partial => 'cell',
      :locals => { :user_id =>params[:user_id], :cond =>nil, :date =>params[:date] }
  end

  def create
    # �o�^�f�[�^���Ȃ��̂ŁA�p�����[�^�ɏ]���ĐV�K�ɍ쐬�A�ۑ����܂�
    @condition = Condition.new(
      :user_id=>params[:user_id], :date=>params[:date], :name=>params[:id] )
    if @condition.save
      flash[:notice] = 'Condition was successfully created.'
      # �Z���̕\�����쐬�����f�[�^�ɑΉ�����A�C�R���ōX�V���܂�
      render :partial => 'cell',
        :locals => { :user_id =>params[:user_id], :cond =>@condition, :date =>params[:date] }
    else
      # �ۑ��Ɏ��s�����Ƃ��̓G���[���b�Z�[�W��\�����܂�
      flash[:notice] = "Condition creation was failed."
      render :inline => %{<p>Creation Failed</p> <%= debug(@params) %>}
    end
  end
  
  def update
    # �o�^�f�[�^���������̂ŁA�p�����[�^�ɏ]���ăf�[�^���X�V���܂�
    if @condition.update_attributes(:name=>params[:id])
      flash[:notice] = 'Condition was successfully updated.'
      # �Z���̕\�����X�V�����f�[�^�ɑΉ�����A�C�R���ōX�V���܂�
      render :partial => 'cell',
        :locals => { :user_id =>params[:user_id], :cond =>@condition, :date =>params[:date] }
    else
      # �X�V�Ɏ��s�����Ƃ��̓G���[���b�Z�[�W��\�����܂�
      flash[:notice] = "Condition update was failed."
      render :inline => %{<p>Update Failed</p> <%= debug(@params) %>}
    end
  end
  
  private :clear, :create, :update

end
