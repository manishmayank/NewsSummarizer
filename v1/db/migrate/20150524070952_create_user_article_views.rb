class CreateUserArticleViews < ActiveRecord::Migration
  def change
    create_table :user_article_views, :id => false do |t|
      t.integer :user_id
      t.integer :article_id
      t.string :type
      t.text :data
      t.datetime :view_time
      t.timestamps null: false
    end
    add_index :user_article_views, ["user_id", "article_id"]
  end
end
