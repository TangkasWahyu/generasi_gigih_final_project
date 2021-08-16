require_relative '../db/mysql_connector'

class Hashtag
    attr_reader :text

    def initialize(text)
        @text = text
    end

    def save_on(text)
        client = create_db_client
        insert_hashtag_query = "insert into hashtags (text, post_id) values ('#{@text}', #{text.id})"

        client.query(insert_hashtag_query)
        hashtag_id = client.last_id
    end

    def self.contained?(text)
        not (text =~ /[#]\w+/).nil?
    end

    def self.get_hashtags_by_text(text)
        text.downcase.scan(/[#]\w+/).uniq
    end

    def self.fetch_trending
        client = create_db_client
        top_5_trending_24_hours_hashtags = Array.new

        fetch_trending_24_hours_query = "select hashtags.text, count(hashtags.text) as total from posts left join hashtags on hashtags.post_id = posts.id where date >= DATE_SUB(NOW(), INTERVAL 1 DAY) group by hashtags.text order by total desc limit 5;"
        
        rawData = client.query(fetch_trending_24_hours_query)

        rawData.each do |data|
            hashtag = Hashtag.new(data["text"]);
            top_5_trending_24_hours_hashtags.push(hashtag)
        end

        top_5_trending_24_hours_hashtags
    end
end