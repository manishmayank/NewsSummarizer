class ArticlesController < ApplicationController
  before_action :set_article, only: [:show, :edit, :update, :destroy]

  # GET /articles
  # GET /articles.json
  def index
    @articles = Article.all
  end

  # GET /articles/1
  # GET /articles/1.json
  def show
    article = Article.where("id = ?", params[:id]).select("id","category","title","source","source_url","image_url","report_time").first
    likes, shares, tweets, views = calculate_views(article.id)
    summary = Summary.select("summary").where("article_id = ?",article.id).first

    related_list = Array.new
    comments_list = Array.new

    related_articles = Article.where("category = ?", article.category).select("id","category","title","source","source_url","image_url","report_time").order("report_time DESC").limit(25)
    related_articles.each do |related_article|
      rel_likes, rel_shares, rel_tweets, rel_views = calculate_views(related_article.id) 
      related_list << article_list_create(related_article, rel_likes, rel_shares, rel_tweets, rel_views)
    end

    comments_list = comment_list_create(article.id)

    if session[:user_id]
      UserArticleView.new(:user_id => session[:user_id], :article_id => params[:id], :type => "view", :view_time => (Time.now.to_f * 1000).to_i)
    else
      UserArticleView.new(:article_id => params[:id], :type => "view", :view_time => (Time.now.to_f * 1000).to_i)
    end

    render :json {
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

    # add to log view when rendering complete
  end

  # GET /articles/new
  def new
    @article = Article.new
  end

  # GET /articles/1/edit
  def edit
  end

  # POST /articles
  # POST /articles.json
  def create
    @article = Article.new(article_params)

    respond_to do |format|
      if @article.save
        format.html { redirect_to @article, notice: 'Article was successfully created.' }
        format.json { render :show, status: :created, location: @article }
      else
        format.html { render :new }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /articles/1
  # PATCH/PUT /articles/1.json
  def update
    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to @article, notice: 'Article was successfully updated.' }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1
  # DELETE /articles/1.json
  def destroy
    @article.destroy
    respond_to do |format|
      format.html { redirect_to articles_url, notice: 'Article was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def sort
    if (params[:category] == 'empty')
      articles = Article.select("id","category","title","source","source_url","image_url","report_time").order("report_time DESC").limit(50).offset((params[:page_num].to_i - 1) * 50)
    else
      articles = Article.select("id","category","title","source","source_url","image_url","report_time").where("category = ? ",params[:category]).order("report_time DESC").limit(50).offset((params[:page_num].to_i - 1) * 50)
    end   
    categories = Article.select("DISTINCT(category)").order("category ASC")
    articles_list = Array.new
    articles.each do |article|
      likes, shares, tweets, views = calculate_views(article.id)
      articles_list << article_list_create(article, likes, shares, tweets, views)
    end
    render :json {categories: categories, articles: articles_list}
  end

  def search
    # to use full text search of postgresql
    # Can do some preprocessing on query parameter
    articles = Article.search_by_full_content(params[:query])
    if params[:category] != 'empty'
      articles.each do |article|
        if article.category!=params[:category]
          articles.delete(article)
        end
      end
    end

  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def article_params
      params[:article]
    end
end
