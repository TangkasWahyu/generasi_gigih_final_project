require_relative '../models/user'

class UserController
    def self.save(user_attribute)
        user = User.new(user_attribute)
        user.save
    end
end
