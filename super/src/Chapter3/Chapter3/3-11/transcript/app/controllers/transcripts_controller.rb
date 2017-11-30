class TranscriptsController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @transcript_pages, @transcripts = paginate :transcripts, :per_page => 10
    #プライベートメソッドであるget_taglistを呼び出す
    get_taglist
  end

  def show
    @transcript = Transcript.find(params[:id])
  end

  def new
    @transcript = Transcript.new
  end

  def create
    @transcript = Transcript.new(params[:transcript])

    @transcript.user_id = session[:user].id
    if @transcript.save
      flash[:notice] = "議事録の登録に成功しました。"
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @transcript = Transcript.find(params[:id])
  end

  def update
    @transcript = Transcript.find(params[:id])
    if @transcript.update_attributes(params[:transcript])
      flash[:notice] = 'Transcript was successfully updated.'
      redirect_to :action => 'show', :id => @transcript
    else
      render :action => 'edit'
    end
  end

  def destroy
    Transcript.find(params[:id]).destroy
    redirect_to :action => 'list'
  end

  def get_transcript
    @transcript = Transcript.find(params[:id])
    send_data(@transcript.file,:filename => @transcript.filename,
                               :type      => @transcript.content_type,
                               :disposition => "inline")
  end

  def tagsearch
    if params[:tag] then
      #パラメータとしてtagを受け取った場合には検索条件に指定する
        @transcript_pages, @transcripts = paginate :transcripts,
                                          :per_page=>10, 
                                          :conditions=> ["tag=?",params[:tag]]
    else
        @transcript_pages, @transcripts = paginate :transcripts, :per_page => 10
    end
      get_taglist
    render :action => 'list'
  end

  private

  def get_taglist
    @transcript_tags = Transcript.find  :all,:select => 'tag' ,:group  => 'tag'
  end

end
