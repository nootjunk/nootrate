class CommentsController < ApplicationController
  before_action :set_comment, only: [:show, :edit, :update, :destroy, :vote]
  before_filter :must_be_admin, only: [:new, :edit, :destroy]

  respond_to :html

  def index
    @comments = Comment.all
    respond_with(@comments)
  end

  def show
    respond_with(@comment)
  end

  def new
  end

  def edit
  end

  def create
    if !current_user
      redirect_to :back, notice: "You must be logged in to comment."
    elsif verify_recaptcha
      @comment = Comment.new(comment_params)
      @comment.save
      redirect_to :back, notice: "Comment added."
    else
      flash[:notice] = "CAPTCHA failed."
      session[:comment] = comment_params[:comment]
      redirect_to :back
    end
  end

  def update
    @comment.update(comment_params)
    respond_with(@comment)
  end

  def destroy
    @comment.destroy
    respond_with(@comment)
  end

  def vote
    weight = params[:w]

    unless ['-1', '1'].member? weight
      raise "Bad weight."
    end
    
    user_vote = current_user.voted_as_when_voted_for @comment
    if weight == '1'
      user_vote != true ? (@comment.liked_by current_user) : (@comment.unliked_by current_user)
    else
      user_vote != false ? (@comment.disliked_by current_user) : (@comment.undisliked_by current_user)
    end
    #redirect_to(:back)

    render nothing: true
  end

  private
    def must_be_admin
      unless current_user && current_user.role == :admin
        redirect_to root_path, notice: "You don't have permission for this action."
      end
    end

    def set_comment
      @comment = Comment.find(params[:id])
    end

    def comment_params
      params.require(:comment).permit(:comment, :rating_id, :subject_id, :tag_id, :subject_name, :tag_name)
    end
end
