class CreateUserRecommend < ActiveRecord::Migration
  def change
    create_table :user_recommends, :id => false do |t|
    	t.integer :user_id
    	t.integer :article_id
    end
    add_index :user_recommends, ["user_id", "article_id"]
  end
end
