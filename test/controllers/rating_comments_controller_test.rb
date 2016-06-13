require 'test_helper'

class RatingCommentsControllerTest < ActionController::TestCase
  setup do
    @rating_comment = rating_comments(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:rating_comments)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create rating_comment" do
    assert_difference('RatingComment.count') do
      post :create, rating_comment: { description: @rating_comment.description, rating_id: @rating_comment.rating_id }
    end

    assert_redirected_to rating_comment_path(assigns(:rating_comment))
  end

  test "should show rating_comment" do
    get :show, id: @rating_comment
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @rating_comment
    assert_response :success
  end

  test "should update rating_comment" do
    patch :update, id: @rating_comment, rating_comment: { description: @rating_comment.description, rating_id: @rating_comment.rating_id }
    assert_redirected_to rating_comment_path(assigns(:rating_comment))
  end

  test "should destroy rating_comment" do
    assert_difference('RatingComment.count', -1) do
      delete :destroy, id: @rating_comment
    end

    assert_redirected_to rating_comments_path
  end
end
