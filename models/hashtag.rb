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

    def self.get_trending
        client = create_db_client
        top_5_trending_24_hours_hashtags = Array.new

        get_trending_24_hours_query = "select hashtags.text from hashtags join postHashtags on hashtags.id = postHashtags.hashtag_id join posts on postHashtags.hashtag_id = posts.id where date >= DATE_SUB(NOW(), INTERVAL 1 DAY) group by hashtags.text order by COUNT(hashtags.text) desc limit 5;"
        
        rawData = client.query(get_trending_24_hours_query)

        rawData.each do |data|
            hashtag = Hashtag.new(data["text"]);
            top_5_trending_24_hours_hashtags.push(hashtag)
        end

        top_5_trending_24_hours_hashtags
    end

    def to_s
        "#{@text}"
    end
end