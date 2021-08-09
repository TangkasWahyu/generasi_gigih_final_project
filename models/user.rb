require_relative '../db/mysql_connector'

class User
    attr_accessor :username, :email, :bio_description

    def initialize(attribute)
        @username = attribute["username"]
        @email = attribute["email"]
        @bio_description = attribute["bio_description"]
    end

    def save
        client = create_db_client
        insert_query = "insert into users (username, email, bio_description) values ('#{@username}', '#{@email}', '#{@bio_description}')"
        
        client.query(insert_query)
    end

    def self.get_by_id(id)

    end
end
