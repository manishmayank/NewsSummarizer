class Article < ActiveRecord::Base
	include PgSearch
	pg_search_scope :search_by_full_content, :against => [:title, :content, :category, :source]
	has_and_belongs_to_many :keywords
	has_many :read_later, :through => :bookmarks, :class_name => "User"
	has_many :seen, :through => :user_article_views, :class_name => "User"
	has_many :suggested, :through => :user_recommends, :class_name => "User"
end
