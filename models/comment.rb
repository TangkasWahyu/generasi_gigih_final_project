require_relative 'post'
require_relative 'hashtag'

class Comment < Post
    attr_reader :post

    def initialize(attribute)
        super(attribute)
        @post = attribute["post"]
    end
    
    def send
        return if self.is_characters_maximum_limit?

        client = create_db_client
        insert_comment_query = "insert into comments (user_id, post_id, text) values ('#{@user.id}', '#{@post.id}', '#{@text}')"

        client.query(insert_comment_query)
        comment_id = client.last_id

        @id = comment_id

        self.save_hashtags
    end

    def add_post(post)
        @post = post
    end
end