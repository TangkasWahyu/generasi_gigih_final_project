require_relative '../models/user'
require_relative '../models/post'
require_relative '../models/comment'
require_relative '../models/attachment'

class UserController
    def self.save(user_attribute)
        user = User.new(user_attribute)
        user.save
    end

    def self.post(params)
        post_attribute = {
            "text" => params["text"]
        }

        user = User.fetch_by_id(params["id"])
        post = Post.new(post_attribute)

        if params["attachment"]
            attachment = Attachment.new(params["attachment"]) 
            post.set_attachment(attachment)
        end
        
        user.send(post)
    end

    def self.comment(params)
        comment_attribute = {
            "text" => params["text"]
        }

        user = User.fetch_by_id(params["user_id"])
        post = Post.get_by_id(params["post_id"])
        comment = Comment.new(comment_attribute)

        if params["attachment"]
            attachment = Attachment.new(params["attachment"]) 
            comment.set_attachment(attachment)
        end

        user.on(post).send(comment)
    end
end
