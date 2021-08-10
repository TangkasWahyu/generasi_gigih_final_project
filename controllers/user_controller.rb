require_relative '../models/user'
require_relative '../models/post'


class UserController
    def self.save(user_attribute)
        user = User.new(user_attribute)
        user.save
    end

    def self.post(params)
        post_attribute = {
            "text" => params["text"]
        }

        user = User.get_by_id(params["id"])
        post = Post.new(post_attribute)
        post.save_hashtags

        user.post(post)
    end
end
