class User
    attr_accessor :username, :email, :bio_description

    def initialize(attribute)
        @username = attribute["username"]
        @email = attribute["email"]
        @bio_description = attribute["bio_description"]
    end

    def save
        
    end
end