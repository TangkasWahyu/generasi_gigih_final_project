require_relative '../models/post'

class PostController
    def self.save(params)
        post = Post.new(params)
        post.save(params)
    end
end
