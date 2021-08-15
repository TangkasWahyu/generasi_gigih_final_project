require_relative '../db/mysql_connector'

class Hashtag
    attr_reader :text

    def initialize(text)
        @text = text
    end

    def self.contained?(text)
        not (text =~ /[#]\w+/).nil?
    end

    def self.get_hashtags_by_text(text)
        text.downcase.scan(/[#]\w+/).uniq
    end

    def save_on(text)
        client = create_db_client
        insert_hashtag_query = "insert into hashtags (text) values ('#{@text}')"

        client.query(insert_hashtag_query)
        hashtag_id = client.last_id

        insert_hashtag_referenced_query = text.get_insert_hashtag_referenced_query(hashtag_id)
        client.query(insert_hashtag_referenced_query)
    end

    def self.get_trending
        client = create_db_client
        top_5_trending_24_hours_hashtags = Array.new

        get_trending_24_hours_query = "select text, COUNT(text) as total from ( select hashtags.text as 'text', posts.date as 'date' from hashtags join postHashtags on hashtags.id = postHashtags.hashtag_id join posts on postHashtags.post_id = posts.id union all select hashtags.text as 'text', comments.date as 'date' from hashtags join commentHashtags on hashtags.id = commentHashtags.hashtag_id join comments on commentHashtags.comment_id = comments.id )as postAndCommentHashtag where date >= DATE_SUB(NOW(), INTERVAL 1 DAY) group by text order by total desc limit 5;"
        
        rawData = client.query(get_trending_24_hours_query)

        rawData.each do |data|
            hashtag = Hashtag.new(data["text"]);
            top_5_trending_24_hours_hashtags.push(hashtag)
        end

        top_5_trending_24_hours_hashtags
    end
end