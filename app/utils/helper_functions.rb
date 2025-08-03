require 'uri'

module HelperFunctions
  def all_elements_integers?(array)
    if !array.is_a?(Array)
      puts "arrays in not an Array."
      false
    elsif array.empty?
      puts "array is an empty array."
      false
    else
      array.each do |element|
        return false unless element.is_a?(Integer) and element >= 0
      end
      true
    end
  end

  def empty_array?(array)
    true if array.empty?
    false
  end

  def has_duplicates?(array)
    array.uniq.length != array.length
  end

  def validate_story_object(story_object)
    false unless story_object.is_a? Hash
    false if story_object.keys.empty?
    false if story_object.values.include? nil
    story_object.each do |key, value|
      case key
      when "id", "time", "score", "descendants"
        false if story_object[key].class != Integer
      when "deleted", "dead"
        false if story_object[key].class != FalseClass or story_object[key].class != TrueClass
      when "type"
        false unless ["job", "story", "comment", "poll", "pollopt"].include? story_object[key]
      when "by", "text", "parent", "poll", "url", "title"
        false if story_object[key].class != String
      when "kids", "parts"
        false if story_object[key].class != Array
      end
    end
    true
  end

  def validate_top_story_object(top_story_object)
    validate_story_object(top_story_object)
  end

  def validate_comment_object(comment_object)
    false unless comment_object.is_a? Hash
    false if comment_object.keys.empty?
    false if comment_object.values.include? nil
    if comment_object["by"] != nil
      comment_object.each do |key, value|
        case key
        when "id", "time", "parent"
          false if comment_object[key].class != Integer
        when "type"
          false unless comment_object["type"] == "comment"
        when "by", "type"
          false if comment_object[key].class != String
        when "text"
          false if comment_object[key].class != String
          false if comment_object[key].length <= 0
        when "kids"
          false if comment_object[key].class != Array
        when "deleted"
          false if comment_object[key].class != TrueClass
        end
      end
      true
    end
  end

  def valid_url?(string)
    uri = URI.parse(string)
    uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)
  rescue URI::InvalidURIError
    false
  end
end