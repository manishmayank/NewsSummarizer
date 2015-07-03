class CreateSummaries < ActiveRecord::Migration
  def change
    create_table :summaries, :id => false do |t|
      t.integer :article_id
      t.text :summary
      t.timestamps null: false
    end
    add_index :summaries, ["article_id"]
  end
end
