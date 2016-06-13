class SearchController < ApplicationController
  respond_to :html

  def index
  	if !params.key?(:search)
  		redirect_to 'asdasd'
  	else
  		@subjects = Subject.where('safe_name LIKE ?', "#{params[:search]}%")
  		@tags = Tag.where('safe_name LIKE ?', "#{params[:search]}%")
      @comments = Comment.where('comment LIKE ?', "%#{params[:search]}%")
  	end
  end

  private
    def search_params
      params[:search]
    end
end
