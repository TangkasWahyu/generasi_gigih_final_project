class HashtagController
    def self.trending
        Hashtag.get_trending
    end
    
    def self.get_by_hashtag_text(params)
        Post.fetch_by_hashtag_text(params["hashtag_text"])
    end
end