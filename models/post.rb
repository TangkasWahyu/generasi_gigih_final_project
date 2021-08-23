require_relative 'hashtag'
require_relative '../db/mysql_connector'

class Post
  attr_reader :text, :id, :attachment, :user

  def initialize(attribute)
    @text = attribute['text']
    @id = attribute['id']
    @attachment = attribute['attachment']
    @user = attribute['user']
  end

  def send_by(user)
    return if is_characters_maximum_limit?

    @user = user

    save
  end

  def is_characters_maximum_limit?
    @text.length > 1000
  end

  def save
    client = create_db_client
    insert_query = get_insert_query

    client.query(insert_query)
    @id = client.last_id

    save_hashtags if Hashtag.contained?(@text)
  end

  def get_insert_query
    if @attachment
      @attachment.attached_by(@user)

      "insert into posts (user_id, text, attachment_path) values ('#{@user.id}','#{@text}', '#{@attachment.saved_filename}')"
    else
      "insert into posts (user_id, text) values ('#{@user.id}','#{@text}')"
    end
  end

  def save_hashtags
    hashtag_texts = Hashtag.get_hashtags_by_text(@text)

    hashtag_texts.each do |hashtag_text|
      hashtag = Hashtag.new(hashtag_text)
      hashtag.save_on(self)
    end
  end

  def set_attachment(attachment)
    @attachment = attachment
  end

  def self.fetch_by_id(id)
    client = create_db_client
    posts = []

    raw_data = client.query("select * from posts where id = #{id}")

    raw_data.each do |data|
      post = Post.new(data)
      posts.push(post)
    end

    posts.pop
  end

  def self.fetch_by_hashtag_text(hashtag_text)
    client = create_db_client
    posts = []
    fetch_by_hashtag_text_query = "select * from posts left join postRefs on posts.id = postRefs.post_id where postRefs.post_ref_id is null and posts.text like '%##{hashtag_text}%';"

    raw_data = client.query(fetch_by_hashtag_text_query)

    raw_data.each do |data|
      post = Post.new(data)
      posts.push(post)
    end

    posts
  end

  private :get_insert_query, :save_hashtags, :save, :is_characters_maximum_limit?
end
