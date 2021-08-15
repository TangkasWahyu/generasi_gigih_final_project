require_relative 'post'
require_relative 'hashtag'

class Comment < Post
    attr_reader :post

    def initialize(attribute)
        super(attribute)
    end

    def save_by(user)
        super(user)
        save_ref(user)
    end

    def save_ref(user)
        client = create_db_client
        post = user.post

        insert_post_ref_query = "insert into postRefs (post_id, post_ref_id) values (#{@id}, #{post.id})"
        client.query(insert_post_ref_query)
    end
end