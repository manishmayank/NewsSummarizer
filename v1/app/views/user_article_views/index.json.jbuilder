json.array!(@user_article_views) do |user_article_view|
  json.extract! user_article_view, :id
  json.url user_article_view_url(user_article_view, format: :json)
end
