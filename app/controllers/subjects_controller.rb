class SubjectsController < ApplicationController
  before_action :set_subject, only: [:show, :edit, :update, :destroy]
  before_filter :must_be_admin, only: [:edit, :destroy]

  # GET /subjects
  # GET /subjects.json
  def index
  #  @subjects = Subject.all
  end

  # GET /subjects/1
  # GET /subjects/1.json
  def show
  end

  # GET /subjects/new
  def new
  end

  # GET /subjects/1/edit
  def edit
  end
  
  # POST /subjects
  # POST /subjects.json
  def create
    # check if already exists
    @subject = Subject.find_by_safe_name(subject_params[:name].parameterize('_'));
    existed = true;

    # create otherwise
    if @subject == nil
      @subject = Subject.new(name: subject_params[:name], safe_name: subject_params[:name].parameterize('_'), description: subject_params[:description]);
      existed = false;
    end

    respond_to do |format|
      if @subject.save
        format.html { redirect_to @subject, notice: (existed ? 'Subject already existed.' : 'Subject was successfully created.') }
        format.json { render :show, status: :created, location: @subject }
      else
        format.html { render :new }
        format.json { render json: @subject.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /subjects/1
  # PATCH/PUT /subjects/1.json
  def update
    respond_to do |format|
      if @subject.update(subject_params)
        format.html { redirect_to @subject, notice: 'Subject was successfully updated.' }
        format.json { render :show, status: :ok, location: @subject }
      else
        format.html { render :edit }
        format.json { render json: @subject.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /subjects/1
  # DELETE /subjects/1.json
  def destroy
    Rating.where(subject: @subject).find_each do |rating|
      # Destroy votes for this subject.
      Vote.where(votable_type: :Rating, votable_id: rating.id).destroy_all
      # Destroy rating
      rating.destroy
    end

    @subject.destroy

    respond_to do |format|
      format.html { redirect_to subjects_url, notice: 'Subject was successfully destroyed.' }
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
    def set_subject
      @subject = Subject.where('safe_name = ?', params[:id]).first
    end
    
    # Never trust parameters from the scary internet, only allow the white list through.
    def subject_params
      params.require(:subject).permit(:name, :description, :rating_id)
    end
end
