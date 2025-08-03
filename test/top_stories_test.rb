require 'minitest/autorun'
require_relative '../app/client/hackernews_client'
require_relative '../app/utils/helper_functions'
require_relative '../app/constants/endpoints'

class TopStoriesTests < Minitest::Test
  include HelperFunctions
  include Endpoints

  def setup
    @client = HackerNewsClient.new
  end

  def test_response_is_array
    story_ids = @client.get_ids_of_top_stories({ "print" => "pretty" })
    assert(story_ids.is_a?(Array), "Expected top story IDs to be an Array, got #{story_ids.class}")
  end

  def test_get_top_stories_response_time_under_500
    start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    top_stories = @client.get_ids_of_top_stories({ "print" => "pretty" })
    end_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    response_time_ms = ((end_time - start_time) * 1000).round(2)
    assert(response_time_ms < 500, "Expected top stories to be retrieved in under 500ms, got #{response_time_ms}ms")
  end

  def test_response_is_array_without_param_print_pretty
    story_ids = @client.get_ids_of_top_stories
    assert(story_ids.is_a?(Array), "Expected top story IDs to be an Array, got #{story_ids.class}")
  end

  def test_response_is_not_empty
    story_ids = @client.get_ids_of_top_stories({ "print" => "pretty" })
    assert(!empty_array?(story_ids), "Expected top story IDs not to be empty")
  end

  def test_all_story_ids_are_integers
    story_ids = @client.get_ids_of_top_stories({ "print" => "pretty" })
    assert(all_elements_integers?(story_ids), "Expected all story IDs to be integers")
  end

  def test_story_ids_do_not_exceed_500
    story_ids = @client.get_ids_of_top_stories({ "print" => "pretty" })
    assert(story_ids.length <= 500, "Expected 500 or fewer top story IDs")
  end

  def test_story_ids_are_unique
    story_ids = @client.get_ids_of_top_stories({ "print" => "pretty" })
    assert(!has_duplicates?(story_ids), "Expected story IDs to be unique")
  end

  def test_story_objects_by_random_ids
    story_ids = @client.get_ids_of_top_stories({ "print" => "pretty" })
    story_ids_sample = story_ids.sample((story_ids.length * 0.02).round)
    story_ids_sample.each do |story_id|
      story_by_id = @client.get_story_by_id(story_id)
      assert(validate_story_object(story_by_id), "Story object values: datatypes are not valid.")
    end
  end
end
