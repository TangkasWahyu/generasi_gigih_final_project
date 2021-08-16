require_relative '../db/mysql_connector'

class User
    attr_reader :username, :email, :bio_description, :id, :post

    def initialize(attribute)
        @username = attribute["username"]
        @email = attribute["email"]
        @bio_description = attribute["bio_description"]
        @id = attribute["id"]
        @post = attribute["post"]
    end

    def save
        client = create_db_client
        insert_query = "insert into users (username, email, bio_description) values ('#{@username}', '#{@email}', '#{@bio_description}')"
        
        client.query(insert_query)
    end

    def self.fetch_by_id(id)
        client = create_db_client
        users = Array.new
    
        rawData = client.query("select * from users where id = #{id}")
    
        rawData.each do |data|
            user = User.new(data);
            users.push(user)
        end

        users.pop
    end

    def send(post)
        post.send_by(self)
    end

    def on(post)
        @post = post

        self
    end
end
