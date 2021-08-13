require_relative 'post'
require_relative 'hashtag'

class Comment < Post
    attr_reader :post

    def initialize(attribute)
        super(attribute)
        @post = attribute["post"]
    end
    
    def get_insert_query_and_save_attachment_if_attached
        if @attachment
            @attachment.save
            attachment_path = "/public/#{@attachment.filename}"

            return "insert into comments (user_id, post_id, text, attachment_path) values ('#{@user.id}', '#{@post.id}', '#{@text}', '#{attachment_path}')"
        else
            return "insert into comments (user_id, post_id, text) values ('#{@user.id}', '#{@post.id}', '#{@text}')"
        end
    end

    def save_hashtags
        hashtags = get_hashtags
        client = create_db_client
        
        hashtag_ids = Hashtag.save_hashtags(hashtags)

        hashtag_ids.each do |hashtag_id|
            insert_query = "insert into commentHashtags (comment_id, hashtag_id) values (#{@id}, #{hashtag_id})"
            client.query(insert_query)
        end
    end

    def add_post(post)
        @post = post
    end
end