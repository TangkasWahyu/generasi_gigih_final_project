require_relative '../models/user'
require_relative '../models/post'
require_relative '../models/comment'

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
        attachment = Attachment.new(params["attachment"]) if params["attachment"]
        post = Post.new(post_attribute)
        post.add_user(user)
        post.set_attachment(attachment) if params["attachment"]
        
        post.send
    end

    def self.comment(params)
        comment_attribute = {
            "text" => params["text"]
        }

        user = User.get_by_id(params["user_id"])
        post = Post.get_by_id(params["post_id"])
        comment = Comment.new(comment_attribute)
        comment.add_user(user)
        comment.add_post(post)

        comment.send
    end
end
