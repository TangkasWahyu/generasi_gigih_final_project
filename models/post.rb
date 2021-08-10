require_relative 'hashtag'
require_relative '../models/hashtag'

class Post
    attr_reader :text

    def initialize(attribute)
        @text = attribute["text"]
    end

    def save_hashtags
        hashtags = self.get_hashtags
        
        Hashtag.save_hashtags(hashtags)
    end

    def get_hashtags
        @text.scan(/[#]\w+/)
    end
end