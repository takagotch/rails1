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
  end

  def show
    @transcript = Transcript.find(params[:id])
  end

  def new
    @transcript = Transcript.new
  end

  def create
    @transcript = Transcript.new(params[:transcript])
    if @transcript.save
      flash[:notice] = 'Transcript was successfully created.'
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
end
