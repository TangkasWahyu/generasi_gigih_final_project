require_relative 'hashtag'
require_relative '../db/mysql_connector'

class Post
    attr_reader :text, :id, :attachment

    def initialize(attribute)
        @text = attribute["text"]
        @id = attribute["id"]
        @attachment = attribute["attachment"]
    end

    def send_by(user)
        return if is_characters_maximum_limit?

        save_by(user)

        save_hashtags if Hashtag.contained?(@text)
    end

    def is_characters_maximum_limit?
        @text.length > 1000
    end

    def save_by(user)
        client = create_db_client
        insert_post_query = get_insert_query_and_save_attachment_if_attached_by(user)

        client.query(insert_post_query)
        @id = client.last_id
    end

    def save_hashtags
        hashtag_texts = Hashtag.get_hashtags_by_text(@text) 

        hashtag_texts.each do |hashtag_text|
            hashtag = Hashtag.new(hashtag_text)
            hashtag.save_on(self)
        end
    end

    def get_insert_query_and_save_attachment_if_attached_by(user)
        if @attachment
            @attachment.save
            attachment_path = "/public/#{@attachment.filename}"
            
            return "insert into posts (user_id, text, attachment_path) values ('#{user.id}','#{@text}', '#{attachment_path}')"
        else
            return "insert into posts (user_id, text) values ('#{user.id}','#{@text}')"
        end
    end

    def get_insert_hashtag_referenced_query(hashtag_id)
        "insert into postHashtags (post_id, hashtag_id) values (#{@id}, #{hashtag_id})"
    end

    def set_attachment(attachment)
        @attachment = attachment
    end

    def self.get_by_id(id)
        client = create_db_client
        posts = Array.new
    
        rawData = client.query("select * from posts where id = #{id}")
    
        rawData.each do |data|
            post = Post.new(data);
            posts.push(post)
        end

        posts.pop
    end

    def self.fetch_by_hashtag_text(hashtag_text)
        client = create_db_client
        posts = Array.new
        fetch_by_hashtag_text_query = "select * from posts where text like '%#{hashtag_text}%'"
    
        rawData = client.query(fetch_by_hashtag_text_query)
    
        rawData.each do |data|
            post = Post.new(data);
            posts.push(post)
        end

        posts
    end
end