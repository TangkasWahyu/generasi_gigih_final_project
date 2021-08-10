require_relative 'hashtag'
require_relative '../models/hashtag'

class Post
    attr_reader :text

    def initialize(attribute)
        @text = attribute["text"]
    end

    def is_characters_maximum_limit?
        @text.length > 1000
    end

    def save_hashtags
        hashtags = self.get_hashtags
        
        Hashtag.save_hashtags(hashtags)
    end

    def get_hashtags
        @text.downcase.scan(/[#]\w+/)
    end
end