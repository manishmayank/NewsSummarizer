class UserArticleViewsController < ApplicationController
  # before_action :set_user_article_view, only: [:show, :edit, :update, :destroy]

  # GET /user_article_views
  # GET /user_article_views.json
  def index
    @user_article_views = UserArticleView.all
  end

  # GET /user_article_views/1
  # GET /user_article_views/1.json
  def show
  end

  # GET /user_article_views/new
  def new
    @user_article_view = UserArticleView.new
  end

  # GET /user_article_views/1/edit
  def edit
  end

  # POST /user_article_views
  # POST /user_article_views.json
  def create
    @user_article_view = UserArticleView.new(user_article_view_params)

    respond_to do |format|
      if @user_article_view.save
        format.html { redirect_to @user_article_view, notice: 'User article view was successfully created.' }
        format.json { render :show, status: :created, location: @user_article_view }
      else
        format.html { render :new }
        format.json { render json: @user_article_view.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /user_article_views/1
  # PATCH/PUT /user_article_views/1.json
  def update
    respond_to do |format|
      if @user_article_view.update(user_article_view_params)
        format.html { redirect_to @user_article_view, notice: 'User article view was successfully updated.' }
        format.json { render :show, status: :ok, location: @user_article_view }
      else
        format.html { render :edit }
        format.json { render json: @user_article_view.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_article_views/1
  # DELETE /user_article_views/1.json
  def destroy
    @user_article_view.destroy
    respond_to do |format|
      format.html { redirect_to user_article_views_url, notice: 'User article view was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def comment
    unless session[:user_id]
      render :json {
        success: false,
        reason: "user not logged in"
      }
      return
    end
    comment_view = UserArticleView.new(:user_id => params[:user_id], :article_id => params[:article_id], :type => "comment", :data => params[:comment], :view_time => (Time.now.to_f * 1000).to_i)
    if comment_view.save
      render :json {
        success: true
      }
    else
      render: json {
        success: false
      }
    end
  end

  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_article_view
      @user_article_view = UserArticleView.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_article_view_params
      params[:user_article_view]
    end
end
