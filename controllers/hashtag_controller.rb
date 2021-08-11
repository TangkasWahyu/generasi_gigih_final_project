class HashtagController
    def self.trending
        Hashtag.get_trending
    end
end