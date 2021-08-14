require_relative 'hashtag'
require_relative '../db/mysql_connector'

class Post
    attr_reader :text, :id, :user, :attachment

    def initialize(attribute)
        @text = attribute["text"]
        @id = attribute["id"]
        @user = attribute["user"]
        @attachment = attribute["attachment"]
    end

    def send 
        return if is_characters_maximum_limit?

        client = create_db_client
        insert_post_query = get_insert_query_and_save_attachment_if_attached

        client.query(insert_post_query)
        post_id = client.last_id
        @id = post_id

        save_hashtags
    end

    def is_characters_maximum_limit?
        @text.length > 1000
    end

    def get_insert_query_and_save_attachment_if_attached
        if @attachment
            @attachment.save
            attachment_path = "/public/#{@attachment.filename}"
            
            return "insert into posts (user_id, text, attachment_path) values ('#{@user.id}','#{@text}', '#{attachment_path}')"
        else
            return "insert into posts (user_id, text) values ('#{@user.id}','#{@text}')"
        end
    end

    def save_hashtags
        hashtags = get_hashtags
        client = create_db_client
        
        hashtag_ids = Hashtag.save_hashtags(hashtags)

        hashtag_ids.each do |hashtag_id|
            insert_query = get_insert_hashtag_referenced_query(hashtag_id)
            client.query(insert_query)
        end
    end

    def get_insert_hashtag_referenced_query(hashtag_id)
        "insert into postHashtags (post_id, hashtag_id) values (#{@id}, #{hashtag_id})"
    end

    def get_hashtags
        @text.downcase.scan(/[#]\w+/).uniq
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