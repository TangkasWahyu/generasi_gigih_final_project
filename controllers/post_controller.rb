class PostController
    def self.get_by_hashtag(params)
        Post.fetch_by_hashtag(params["hashtag_text"])
    end
end