class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :title
      t.text :content
      t.string :image_url
      t.string :category
      t.string :source
      t.string :source_url
      t.datetime :report_time
      t.float :popularity
      t.timestamps null: false
    end
  end
end

