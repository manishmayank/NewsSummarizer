class CreateArticleKeyword < ActiveRecord::Migration
  def change
  	create_table :articles_keywords, :id => false do |t|
  		t.integer :article_id
  		t.integer :keyword_id
  	end
  	add_index :articles_keywords, ["article_id", "keyword_id"]
  end
end
