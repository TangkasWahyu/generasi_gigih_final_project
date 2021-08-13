require_relative '../test_helper'
require_relative '../../models/user'
require_relative '../../models/comment'
require_relative '../../models/post'

describe Comment do
    let(:mock_client) {double}

    before(:each) do
        allow(Mysql2::Client).to receive(:new).and_return(mock_client)
    end

    describe ".get_insert_query_and_save_attachment_if_attached" do
        let(:user_attribute) {{
            "id" => "1",
            "username" => "mark",
            "email" => "mark@mail.com",
            "bio_description" => "20 years old and grow"
        }}
        let(:user) { User.new user_attribute }
        let(:post_attribute) {{
            "id" => "1",
            "text" => "Hello world #monday"
        }}
        let(:post) { Post.new post_attribute }

        context "comment have attachment" do
            it "should to equal expected" do
                attachment_attribute = {
                    "filename" => "filename", 
                    "tempfile" => "tempfile"
                }
                attachment = Attachment.new(attachment_attribute)

                comment_attribute = {
                    "text" => "Hello world",
                    "user" => user,
                    "attachment" => attachment,
                    "post" => post
                }
                comment = Comment.new(comment_attribute)
                attachment_path = "/public/#{attachment.filename}"
                expected = "insert into comments (user_id, post_id, text, attachment_path) values ('#{user.id}', '#{post.id}', '#{comment.text}', '#{attachment_path}')"

                allow(attachment).to receive(:save)
                actual = comment.get_insert_query_and_save_attachment_if_attached

                expect(actual).to eq(expected)
            end
        end
        
        context "comment don't have attachment" do
            it "should to equal expected" do
                comment_attribute = {
                    "text" => "Hello world",
                    "user" => user,
                    "post" => post
                }
                comment = Comment.new(comment_attribute)
                expected = "insert into comments (user_id, post_id, text) values ('#{user.id}', '#{post.id}', '#{comment.text}')"

                actual = comment.get_insert_query_and_save_attachment_if_attached

                expect(actual).to eq(expected)
            end
        end
    end

    describe "#get_insert_hashtag_referenced_query" do
        context "comment have id and given hashtag_id" do
            it "should to equal expected" do
                hashtag_id = double
                comment_attribute = {
                    "id" => double,
                    "text" => double
                }
                comment_with_id = Comment.new(comment_attribute)
                expected = "insert into commentHashtags (comment_id, hashtag_id) values (#{comment_with_id.id}, #{hashtag_id})"

                actual = comment_with_id.get_insert_hashtag_referenced_query(hashtag_id)

                expect(actual).to eq(expected)
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
