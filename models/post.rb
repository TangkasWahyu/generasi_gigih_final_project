require_relative 'hashtag'
require_relative '../models/hashtag'
require_relative '../db/mysql_connector'

class Post
    attr_reader :text, :id

    def initialize(attribute)
        @text = attribute["text"]
        @id = attribute["id"]
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

    def self.get_by_id(id)
    end
end