class TagsController < ApplicationController
  before_action :set_tag, only: [:show, :edit, :update, :destroy]
  before_filter :must_be_admin, only: [:edit, :destroy]

  # GET /tags
  # GET /tags.json
  def index
  #@tags = Tag.all
  end

  # GET /tags/1
  # GET /tags/1.json
  def show
  end

  # GET /tags/new
  def new
    @tag = Tag.new
  end

  # GET /tags/1/edit
  def edit
  end

  # POST /tags
  # POST /tags.json
  def create
    # check if already exists
    @tag = Tag.find_by_safe_name(tag_params[:name].parameterize('_'));

    if @tag != nil
      flash[:notice] = 'Tag already existed.'
      redirect_to @tag
    
    # create otherwise
    else
      @tag = Tag.new(name: tag_params[:name], safe_name: tag_params[:name].parameterize('_'), description: tag_params[:description]);
      
      # verify captcha
      if !verify_recaptcha
        flash[:notice] = "CAPTCHA failed."
        render :new
      # save and redirect to tag
      elsif @tag.save
        flash[:notice] = 'Tag was successfully created.';
        redirect_to @tag
      else
        flash[:notice] = @tag.errors
        render :new
      end
    end
  end

  # PATCH/PUT /tags/1
  # PATCH/PUT /tags/1.json
  def update
    respond_to do |format|
      if @tag.update(tag_params)
        format.html { redirect_to @tag, notice: 'Tag was successfully updated.' }
        format.json { render :show, status: :ok, location: @tag }
      else
        format.html { render :edit }
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tags/1
  # DELETE /tags/1.json
  def destroy
    Rating.where(tag: @tag).find_each do |rating|
      # Destroy votes for this subject.
      Vote.where(votable_type: :Rating, votable_id: rating.id).destroy_all
      # Destroy rating
      rating.destroy
    end

    @tag.destroy

    respond_to do |format|
      format.html { redirect_to tags_url, notice: 'Tag was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  private
    def must_be_admin
      unless current_user && current_user.role == 'admin'
        redirect_to :back, notice: "You must be signed in and have appropriate permission."
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_tag
      @tag = Tag.where('safe_name = ?', params[:id]).first
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tag_params
      params.require(:tag).permit(:name, :description)
    end
end
