require 'httparty'
require_relative '../constants/endpoints'

class HackerNewsClient
  def get_ids_of_top_stories(params = {})
    params_string = "?"
    params.each do |key, value|
      params_string += "#{key}=#{value}" if params_string.empty?
      params_string += "&#{key}=#{value}" unless params_string.empty?
    end
    response = HTTParty.get("#{Endpoints::BASE_URL}/#{Endpoints::API_VERSION}/#{Endpoints::Paths::TOP_STORIES}")
    if response.code != 200
      raise "
             Failed to fetch top stories.
             Response Code: #{response.code}
             Response Body: #{response.body}
             "
    end
    response.parsed_response
  end

  def get_story_by_id(story_id)
    response = HTTParty.get("#{Endpoints::BASE_URL}/#{Endpoints::API_VERSION}/#{Endpoints::Paths::ITEM.call(story_id)}")
    if response.code != 200
      raise "
             Failed to fetch the story by id:#{story_id}.
             Response Code: #{response.code}
             Response Body: #{response.body}
             "
    end
    response.parsed_response
  end

  def get_first_comment(comment_id)
    response = HTTParty.get("#{Endpoints::BASE_URL}/#{Endpoints::API_VERSION}/#{Endpoints::Paths::COMMENT.call(comment_id)}")
    if response.code != 200
      raise "
             Failed to fetch the first comment by comment id:#{comment_id}.
             Response Code: #{response.code}
             Response Body: #{response.body}
             "
    end
    response.parsed_response
  end
end