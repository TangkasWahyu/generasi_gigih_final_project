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
        post_id = user.post(post)

        return if post_id.nil?

        post_attribute = {
            "id" => post_id,
            "text" => params["text"]
        }

        post = Post.new(post_attribute)
        post.save_hashtags
    end
end
