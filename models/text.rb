require_relative 'hashtag'
require_relative '../db/mysql_connector'

class Text
    attr_reader :text, :id, :user

    def initialize(attribute)
        @text = attribute["text"]
        @id = attribute["id"]
        @user = attribute["user"]
    end

    def is_characters_maximum_limit?
        @text.length > 1000
    end

    def save_hashtags
        hashtags = self.get_hashtags
        client = create_db_client
        
        hashtag_ids = Hashtag.save_hashtags(hashtags)

        hashtag_ids.each do |hashtag_id|
            insert_query = "insert into postHashtags (post_id, hashtag_id) values (#{@id}, #{hashtag_id})"
            client.query(insert_query)
        end
    end

    def get_hashtags
        @text.downcase.scan(/[#]\w+/).uniq
    end

    def sent
        client = create_db_client

        insert_post_query = "insert into posts (user_id, text) values ('#{@id}','#{@post.text}')"
        
        return if post.is_characters_maximum_limit?

        client.query(insert_post_query)
        post_id = client.last_id

        post_attribute = {
            "id" => post_id,
            "text" => @post.text
        }

        post = Post.new(post_attribute)
        post.save_hashtags
    end

    def add_user(user)
        @user = user
    end

    def self.get_by_id(id)
    end
end