class Hashtag
    attr_reader :text

    def initialize(text)
        @text = text
    end

    def self.save_hashtags(hashtags)
        hashtags.each do |hashtag|
            hashtag = Hashtag.new(hashtag)
            hashtag.save
        end
    end

    def save
        client = create_db_client
        insert_query = "insert into hashtags (text) values ('#{@text}')"

        client.query(insert_query)

        return client.last_id
    end
end