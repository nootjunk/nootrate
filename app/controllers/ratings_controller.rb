class RatingsController < ApplicationController
  before_action :set_rating, only: [:show, :edit, :update, :destroy, :vote]
  before_filter :must_be_admin, only: [:edit, :destroy]
  
  # GET /ratings
  # GET /ratings.json
  def index
    
  end

  # GET /ratings/1
  # GET /ratings/1.json
  def show
    @comment = Comment.new
  end

  # GET /ratings/new
  def new
    @rating = Rating.new
  end

  # GET /ratings/1/edit
  def edit
  end

  # POST /ratings
  # POST /ratings.json
  def create
    @subject = Subject.find_by_id(rating_params[:subject_id])
    @tag = Tag.find_by_id(rating_params[:tag_id])

    if @subject.nil? or @tag.nil?
      respond_to do |format|
        format.html { redirect_to action: 'new', notice: 'Subject and Tag cant be null.' }
        format.json { render json: @rating.errors, status: :unprocessable_entity }
      end
    else
      @rating = Rating.where(subject_id: rating_params[:subject_id], tag_id: rating_params[:tag_id]).first ||
        Rating.create(
          name: @subject.safe_name + "-" + @tag.safe_name,
          subject_id: rating_params[:subject_id],
          tag_id: rating_params[:tag_id],
          subject_name: @subject.name,
          tag_name: @tag.name)
      
      respond_to do |format|
        if @rating.save
          format.html { redirect_to(:back) }
          format.json { render :show, status: :created, location: @rating }
        else
          format.html { render :new, notice: 'Something went wrong.' }
          format.json { render json: @rating.errors, status: :unprocessable_entity }
        end
      end
    end
  end
  
  # PATCH/PUT /subjects/1
  # PATCH/PUT /subjects/1.json
  def update
    respond_to do |format|
      if @rating.update(rating_params)
        format.html { redirect_to @rating, notice: 'Subject was successfully updated.' }
        format.json { render :show, status: :ok, location: @rating }
      else
        format.html { render :edit }
        format.json { render json: @rating.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /subjects/1
  # DELETE /subjects/1.json
  def destroy
    @rating.destroy
    respond_to do |format|
      format.html { redirect_to ratings_url, notice: 'Subject was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def vote
    unless current_user
      raise "You must sign in to vote."
    end

    weight = params[:w]

    unless ['0', '1', '2', '3', '4'].member? weight
      raise "Bad weight."
    end
      
    # Remove vote if user already voted, otherwise add vote.
    user_vote = Vote.where(votable_type: :Rating, votable_id: @rating.id,
      voter_id: current_user.id)
    if !user_vote.empty? && user_vote.first.vote_weight == weight.to_i
      @rating.unliked_by current_user
    else
      @rating.vote_by voter: current_user, vote: 'up', vote_weight: weight
    end

    # Redirect.
    #redirect_to action: :vote
    render nothing: true
  end

  private
    def must_be_admin
      unless current_user && current_user.role == 'admin'
        redirect_to root_path, notice: "You don't have permission for this action."
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_rating
      @rating = Rating.find_by_name(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def rating_params
      params.require(:rating).permit(:subject_id, :tag_id, :f)
    end
end
