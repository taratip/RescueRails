class CommentsController < ApplicationController

	respond_to :html, :json

  def index
    @commentable = find_commentable
    @comments = @commentable.comments
    render :layout => false
  end

  def show
    @comment = Comment.find(params[:id])
  end

  def new
    @comment = Comment.new
  end

  def create
    @commentable = find_commentable
    @comment = @commentable.comments.build(params[:comment])
    @comment.user_id = current_user.id
    if @comment.save
      flash[:success] = "Comment Saved"
      redirect_to :back
    else
      render :action => 'new'
    end
  end

  def edit
    @comment = Comment.find(params[:id])
  end

  def update
    @comment = Comment.find(params[:id])
    if @comment.user_id == current_user.id
      @comment.update_attributes(params[:comment])
      respond_with @comment
    else
      # return a not authorized
      respond_with @comment, :status => :unauthorized
    end
  end

  private

  def find_commentable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end
    nil
  end

end
