class User < ActiveRecord::Base
	has_secure_password
	has_many :read_later, :through => :bookmarks, :class_name => "Article"
	has_many :seen, :through => :user_article_views, :class_name => "Article"
	has_many :suggested, :through => :user_recommends, :class_name => "Article"
end
