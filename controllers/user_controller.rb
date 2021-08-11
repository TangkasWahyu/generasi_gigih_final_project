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
        user.add_post(post)
        
        user.post
    end

    def self.comment(params)
        user_id_and_post_text = {
            "id" => params["user_id"],
            "text" => params["text"]
        }

        comment_id = UserController.post(user_id_and_post_text)

        post = Post.get_by_id(params["id"])
        post.save_comment(comment_id)
    end
end
