require_relative '../test_helper'
require_relative '../../models/user'
require_relative '../../models/comment'
require_relative '../../models/post'

describe Comment do
    describe "#send" do
        it "should call insert_comment_query" do
            mock_client = double
            user_attribute = {
                "id" => "1",
                "username" => "mark",
                "email" => "mark@mail.com",
                "bio_description" => "20 years old and grow"
            }
            user = User.new(user_attribute)
            post_attribute = {
                "id" => "1",
                "text" => "Hello world #monday"
            }
            post = Post.new(post_attribute)
            comment_attribute = {
                "text" => "Hello world",
                "user" => user,
                "post" => post
            }
            comment = Comment.new(comment_attribute)
            comment_with_id = double
            comment_id = 1
            insert_comment_query = "insert into comments (user_id, post_id, text) values ('#{comment.user.id}', '#{comment.post.id}', '#{comment.text}')"

            allow(Mysql2::Client).to receive(:new).and_return(mock_client)
            expect(mock_client).to receive(:query).with(insert_comment_query)
            allow(mock_client).to receive(:last_id).and_return(comment_id)

            comment.send
        end
    end
end
