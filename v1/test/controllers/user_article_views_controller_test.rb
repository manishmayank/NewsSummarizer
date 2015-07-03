require 'test_helper'

class UserArticleViewsControllerTest < ActionController::TestCase
  setup do
    @user_article_view = user_article_views(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:user_article_views)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user_article_view" do
    assert_difference('UserArticleView.count') do
      post :create, user_article_view: {  }
    end

    assert_redirected_to user_article_view_path(assigns(:user_article_view))
  end

  test "should show user_article_view" do
    get :show, id: @user_article_view
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @user_article_view
    assert_response :success
  end

  test "should update user_article_view" do
    patch :update, id: @user_article_view, user_article_view: {  }
    assert_redirected_to user_article_view_path(assigns(:user_article_view))
  end

  test "should destroy user_article_view" do
    assert_difference('UserArticleView.count', -1) do
      delete :destroy, id: @user_article_view
    end

    assert_redirected_to user_article_views_path
  end
end
