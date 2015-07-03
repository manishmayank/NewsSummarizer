class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :calculate_views, :article_list_create, :comment_list_create

  def calculate_views(article_id)
  	likes = shares = tweets = views = 0
  	article_views = UserArticleView.where("article_id = ?", article_id)
  	article_views.each do |view|
  		if(view.type == "like")
  			likes += 1
  		elsif(view.type == "share")
  			shares += 1
  		elsif(view.type == "tweet")
  			tweets += 1
  		elsif(view.type == "view")
  			views += 1
  		end
	  end
	  return likes, shares, tweets, views
  end

  def article_list_create(article, likes, shares, tweets, views)
  	summary = Summary.select("summary").where("article_id = ?",article.id).first
  	article_to_return = {
    	:id => article.id,
  		:category => article.category,
  		:title => article.title,
  		:source => article.source,
  		:source_url => article.source_url,
  		:image_url => article.image_url,
  		:report_time => article.report_time
  		:summary => summary
  		:likes => likes,
  		:shares => shares,
  		:tweets => tweets,
  		:views => views
  	}
  	return article_to_return
  end

  def comment_list_create(article_id)
  	comments_list = Array.new
  	article_comments = UserArticleView.where("article_id = ?", article.id)
  	article_comments.each do |comment|
  		if(comment.type == "comment")
  			user_name = User.where("id = ?",comment.user_id).select("username").first
  			comments_list << {
  				:user_name => user_name,
  				:comment => comment.data,
  				:time => comment.view_time
  			}
  		end
  	end
  	return comments_list
  end

  def getBookmarks(user_id)
    articles = User.where(:id => user_id).read_later
  end
