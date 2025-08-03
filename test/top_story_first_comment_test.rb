require 'minitest/autorun'
require_relative '../app/client/hackernews_client'
require_relative '../app/utils/helper_functions'
require_relative '../app/constants/endpoints'

class TopStoryFirstCommentTests < Minitest::Test
  include HelperFunctions
  include Endpoints

  def setup
    @client = HackerNewsClient.new
  end

  def test_top_story_has_comments
    story_ids = @client.get_ids_of_top_stories({ "print" => "pretty" })
    story_by_id = @client.get_story_by_id(story_ids.first)
    assert(story_by_id["kids"].length > 0, "Top Story has no comments.")
  end

  def test_can_fetch_first_comment
    story_ids = @client.get_ids_of_top_stories({ "print" => "pretty" })
    story_by_id = @client.get_story_by_id(story_ids.first)
    first_comment_id = story_by_id["kids"][0]
    first_comment = @client.get_first_comment(first_comment_id)
    assert(validate_comment_object(first_comment), "first comment object values: datatypes are not valid.")
  end
end