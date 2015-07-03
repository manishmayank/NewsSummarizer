class HomeController < ApplicationController
	def index
		articles = Article.select("id","category","title","source","source_url","image_url","report_time").order("report_time DESC").limit(50)
		categories = Article.select("DISTINCT(category)").order("category ASC")
		articles_list = Array.new
		articles.each do |article|
			likes, shares, tweets, views = calculate_views(article.id)
			articles_list << article_list_create(article, likes, shares, tweets, views)
		end
		if session[:user_id]
			bookmarks = getBookmarks(session[:user_id])
		end
	bookmarks ? render :json {categories: categories, articles: articles_list} : render :json {categories: categories, articles: articles_list, bookmarks: bookmarks}
	end

	def category
		articles = Article.where("category = ?",params[:category]).select("id","category","title","source","source_url","image_url","report_time").order("report_time DESC").limit(50).offset((params[:page_num].to_i - 1) * 50)
		articles_list = Array.new
		articles.each do |article|
			likes, shares, tweets, views = calculate_views(article.id)
			articles_list << article_list_create(article, likes, shares, tweets, views)
		end
	render :json {category: params[:category], articles: articles_list}
	end

end
