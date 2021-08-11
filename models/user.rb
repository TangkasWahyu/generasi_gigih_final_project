require_relative '../db/mysql_connector'

class User
    attr_accessor :username, :email, :bio_description, :id, :posts

    def initialize(attribute)
        @username = attribute["username"]
        @email = attribute["email"]
        @bio_description = attribute["bio_description"]
        @id = attribute["id"]
        @posts = attribute["posts"] || Array.new
    end

    def save
        client = create_db_client
        insert_query = "insert into users (username, email, bio_description) values ('#{@username}', '#{@email}', '#{@bio_description}')"
        
        client.query(insert_query)
    end

    def self.get_by_id(id)
        client = create_db_client
        users = Array.new
    
        rawData = client.query("select * from users where id = #{id}")
    
        rawData.each do |data|
            user = User.new(data);
            users.push(user)
        end

        users.pop
    end

    def post(post)
        client = create_db_client
        insert_post_query = "insert into posts (user_id, text) values ('#{@id}','#{post.text}')"
        
        return if post.is_characters_maximum_limit?

        client.query(insert_post_query)
        client.last_id
    end

    def add_post(post)
        self.posts << post
    end
end
