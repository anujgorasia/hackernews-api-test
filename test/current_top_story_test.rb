require 'minitest/autorun'
require_relative '../app/client/hackernews_client'
require_relative '../app/utils/helper_functions'
require_relative '../app/constants/endpoints'

class CurrentTopStoryTests < Minitest::Test
  include HelperFunctions
  include Endpoints

  def setup
    @client = HackerNewsClient.new
  end

  def test_top_story_can_be_retrieved
    story_ids = @client.get_ids_of_top_stories({ "print" => "pretty" })
    assert(story_ids.is_a?(Array), "Expected top story IDs to be an Array, got #{story_ids.class}")
    assert(story_ids.first.is_a?(Integer), "Expected top story ID to be an Integer, got #{story_ids.class}" )
    assert(story_ids.first >= 0, "Expected top story ID to be an Integer greater or equal to zero, got #{story_ids.first}" )
    story_by_id = @client.get_story_by_id(story_ids.first)
    assert(story_by_id.is_a?(Hash), "Top Story items can not be retrieved from story id")
  end

  def test_get_current_top_story_response_time_under_500
    top_story_id = @client.get_ids_of_top_stories({ "print" => "pretty" })[0]
    start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    top_story = @client.get_story_by_id(top_story_id)
    end_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    response_time_ms = ((end_time - start_time) * 1000).round(2)
    assert(response_time_ms < 500, "Expected current top story to be retrieved in under 500ms, got #{response_time_ms}ms")
  end


  def test_top_story_type_is_story
    story_ids = @client.get_ids_of_top_stories({ "print" => "pretty" })
    top_story_id = story_ids.first
    story_by_id = @client.get_story_by_id(top_story_id)
    assert(story_by_id["type"] == "story", "Expcted type to be story, got #{story_by_id["type"]}.")
  end

  def test_can_fetch_top_story
    story_ids = @client.get_ids_of_top_stories({ "print" => "pretty" })
    top_story_id = story_ids.first
    story_by_id = @client.get_story_by_id(top_story_id)
    assert(validate_top_story_object(story_by_id), "Story object values: datatypes are not valid.")
  end

  def test_top_story_has_required_fields
    story_ids = @client.get_ids_of_top_stories({ "print" => "pretty" })
    top_story_id = story_ids.first
    story_by_id = @client.get_story_by_id(top_story_id)
    assert((story_by_id["by"].is_a?String and story_by_id["by"].length >= 0), "Auther can not be empty.")
    assert((story_by_id["descendants"].is_a?Integer and story_by_id["descendants"] >= 0), "Auther can not be empty.")
    assert((story_by_id["kids"].is_a?Array), "Auther can not be non Array.")
    assert((story_by_id["score"].is_a?Integer), "Score can not be non Integer.")
    assert((story_by_id["time"].is_a?Integer and story_by_id["time"] > 0), "time can not be non Integer or negative integer.")
    assert((story_by_id["title"].is_a?String and story_by_id["title"].length >= 0), "title can not be empty.")
    assert(valid_url?(story_by_id["url"]), "this is noy a valid url." )
  end

  # Calculating the ranking score for a Hacker News story based on,
  # https://stackoverflow.com/questions/3783892/implementing-the-hacker-news-ranking-algorithm-in-sql
  #
  # Formula:
  #   (score - 1) / (age_in_hours + 2) ^ gravity
  #
  # where p = points and t = age in hours
  def test_is_top_story_really_top_ranked_1
    gravity = 1.5
    now = Time.now.to_i
    story_ids = @client.get_ids_of_top_stories({ "print" => "pretty" })
    top_story_id_retrieved = story_ids.first
    calculated_ranks = {}
    mutex = Mutex.new
    threads = story_ids.map do |story_id|
      Thread.new do
        story = @client.get_story_by_id(story_id)
        age_in_hours = (now - story["time"]).to_f / 3600
        score = story["score"]
        rank_score = ((score - 1).to_f / ((age_in_hours + 2) ** gravity)).round(4)
        mutex.synchronize { calculated_ranks[story["id"]] = rank_score }
      end
    end
    threads.each(&:join)
    max_rank = calculated_ranks.values.max
    top_ranked_story = calculated_ranks.key(max_rank)
    assert(top_story_id_retrieved == top_ranked_story, "Expected top story id to be really top ranked!")
  end
end