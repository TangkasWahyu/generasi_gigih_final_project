require_relative '../models/user'

class UserController
    def self.save(user_attribute)
        user = User.new(user_attribute)
        user.save
    end

    def self.post(params)
        user = User.get_by_id(params["id"])
        post = Post.new(params["text"])

        user.post(post)
    end
end
