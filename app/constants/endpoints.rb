module Endpoints
  API_VERSION = "v0"
  BASE_URL = "https://hacker-news.firebaseio.com/"

  module Paths
    TOP_STORIES = 'topstories.json'
    ITEM = ->(item_id) { "item/#{item_id}.json" }
    COMMENT = ->(comment_id) { "item/#{comment_id}.json" }
  end
end