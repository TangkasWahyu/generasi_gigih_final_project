require_relative 'post'
require_relative 'hashtag'

class Comment < Post
  attr_reader :post

  def save
    super
    client = create_db_client

    insert_post_ref_query = "insert into postRefs (post_id, post_ref_id) values (#{@id}, #{@user.post.id})"
    client.query(insert_post_ref_query)
  end

  private :save
end
