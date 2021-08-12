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

    describe "#save_hashtags" do
        context "comment_attribute contain 1 hashtag" do
            it "should call hashtags and insert_comment_hashtags_query" do
                mock_client = double
                comment_attribute = {
                    "id" => "1",
                    "text" => "Hello world #monday"
                }
                comment_with_id = Comment.new(comment_attribute)
                hashtags = ["monday"]
                hashtag_ids = ["1"]
                insert_comment_hashtags_query = "insert into commentHashtags (comment_id, hashtag_id) values (#{comment_with_id.id}, #{hashtag_ids[0]})"
                
                allow(comment_with_id).to receive(:get_hashtags).and_return(hashtags)
                expect(Hashtag).to receive(:save_hashtags).with(hashtags).and_return(hashtag_ids)
                allow(Mysql2::Client).to receive(:new).and_return(mock_client)
                expect(mock_client).to receive(:query).with(insert_comment_hashtags_query)
    
                comment_with_id.save_hashtags
            end
        end
    end

    describe "#add_post" do
        context "given post_mock" do
            it "should comment.post equal post_mock" do
                comment_attribute = {
                    "text" => "Hello world"
                }
                comment = Comment.new(comment_attribute)
                post_mock = double

                comment.add_post(post_mock)

                expect(comment.post).to eq(post_mock)
            end
        end
    end
end
