class BookmarksController < ApplicationController
  before_action :set_bookmark, only: [:show, :edit, :update, :destroy]

  # GET /bookmarks
  # GET /bookmarks.json
  def index
    unless session[:user_id]
      render :json {
        success: false,
        reason: "user not logged in"
      }
      return
    end
    bookmarks = Bookmark.where("user_id = ?",params[:user_id]).select("article_id")
    article_list = Array.new
    bookmarks.each do |bookmark|
      article = Article.where("id = ?",bookmark.article_id).first
      likes, shares, tweets, views = calculate_views(article.id)
      article_list << article_list_create(article, likes, shares, tweets, views)
    end
    render :json {
      success: true,
      articles: article_list
    }
  end

  # GET /bookmarks/1
  # GET /bookmarks/1.json
  def show
    unless session[:user_id]
      render :json {
        success: false,
        reason: "user not logged in"
      }
      return
    end
    article_relevant = Bookmark.select("article_id").where("id = ?",params[:bookmark_id]).first
    article = Article.where("id = ?",article_relevant.id)

    comments_list = Array.new
    related_list = Array.new

    likes, shares, tweets, views = calculate_views(article.id)
    comments_list = comments_list_create(article.id)

    related_articles = Article.where("category = ?", article.category).select("id","category","title","source","source_url","image_url","report_time").order("report_time DESC").limit(25)
    related_articles.each do |related_article|
      rel_likes, rel_shares, rel_tweets, rel_views = calculate_views(related_article.id)
      related_list << article_list_create(related_article, rel_likes, rel_shares, rel_tweets, rel_views)
    end

    render :json {
      success: true,
      id: article.id,
      category: article.category,
      source: article.source,
      report_time: article.report_time,
      image_url: article.image_url,
      source_url: article.source_url,
      summary: summary,
      comments: comments_list,
      likes: likes,
      shares: shares,
      tweets: tweets,
      views: views,
      comments: comments_list,
      related_articles: related_list
    }
  end

  # GET /bookmarks/new
  def new
    @bookmark = Bookmark.new
  end

  # GET /bookmarks/1/edit
  def edit
  end

  # POST /bookmarks
  # POST /bookmarks.json
  def create
    unless session[:user_id]
      render :json {
        success: false,
        reason: "user not logged in"
      }
      return
    end
    bookmark = Bookmark.new(:user_id => params[:user_id], :article_id => params[:article_id], :saved_time => (Time.now.to_f * 1000).to_i)
    if bookmark.save
      render :json {
        success: true
      }
    else
      render :json {
        success: false
      }
    end
  end

  # PATCH/PUT /bookmarks/1
  # PATCH/PUT /bookmarks/1.json
  def update
    respond_to do |format|
      if @bookmark.update(bookmark_params)
        format.html { redirect_to @bookmark, notice: 'Bookmark was successfully updated.' }
        format.json { render :show, status: :ok, location: @bookmark }
      else
        format.html { render :edit }
        format.json { render json: @bookmark.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bookmarks/1
  # DELETE /bookmarks/1.json
  def destroy
    unless session[:user_id]
      render :json {
        success: false,
        reason: "user not logged in"
      }
      return
    end
    Bookmark.where(user_id: params[:user_id], article_id: params[:article_id]).destroy_all
    render :json {
      success: true
    }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bookmark
      @bookmark = Bookmark.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bookmark_params
      params[:bookmark]
    end
end
