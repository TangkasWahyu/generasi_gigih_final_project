require_relative '../db/mysql_connector'

class Hashtag
    attr_reader :text

    def initialize(text)
        @text = text
    end

    def self.save_hashtags(hashtag_texts)
        hashtag_ids = Array.new

        hashtag_texts.each do |hashtag_text|
            hashtag = Hashtag.new(hashtag_text)
            hashtag_ids << hashtag.save
        end

        hashtag_ids
    end

    def save
        client = create_db_client
        insert_query = "insert into hashtags (text) values ('#{@text}')"

        client.query(insert_query)

        client.last_id.to_s
    end
end