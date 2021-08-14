require_relative '../test_helper'
require_relative '../../models/user'
require_relative '../../models/post'
require_relative '../../models/attachment'

describe Post do
    let(:post_valid_attribute) {{
        "text" => "Hello world"
    }}
    let(:post_valid_attribute_with_id) {{
        "id" => "1",
        "text" => "Hello world"
    }}
    let(:post_valid_attribute_with_id_text_contain_hashtag) {{
        "id" => "1",
        "text" => "Hello world #monday"
    }}
    let(:user_attribute_with_id) {{
        "id" => "1",
        "username" => "mark",
        "email" => "mark@mail.com",
        "bio_description" => "20 years old and grow"
    }}
    let(:user_with_id) { User.new user_attribute_with_id }
    let(:post) { Post.new post_valid_attribute }
    let(:post_with_id) { Post.new post_valid_attribute_with_id }
    let(:post_with_id_text_contain_hashtag) { Post.new post_valid_attribute_with_id_text_contain_hashtag }
    let(:mock_client) {double}

    before(:each) do
        allow(Mysql2::Client).to receive(:new).and_return(mock_client)
    end

    describe ".initialize" do
        context "given valid attribute" do
            it "should create object that equal with valid_attribute" do
                expect(post.text).to eq(post_valid_attribute["text"])
            end
        end
    end

    describe "#send_by" do
        context "given mock_user" do
            it "should call mock_user" do
                mock_user = double
                post_attribute = {
                    "text" => "Hello world"
                }
                post = Post.new(post_attribute)
                
                allow(post).to receive(:is_characters_maximum_limit?).and_return(false)
                expect(post).to receive(:save_by).with(mock_user)
                allow(Hashtag).to receive(:contained?).with(post_attribute["text"]).and_return(true)
                allow(post).to receive(:save_hashtags)
    
                post.send_by(mock_user)
            end
        end
    end

    describe "#get_insert_hashtag_referenced_query" do
        context "post have id and given hashtag_id" do
            it "should to equal expected" do
                hashtag_id = double
                expected = "insert into postHashtags (post_id, hashtag_id) values (#{post_with_id.id}, #{hashtag_id})"

                actual = post_with_id.get_insert_hashtag_referenced_query(hashtag_id)

                expect(actual).to eq(expected) 
            end
        end
    end
    
    describe "#is_characters_maximum_limit?" do
        context "post text characters length below 1000" do
            it "return false" do
                post_attribute = {
                    "text" => "Hello world #monday"
                }
                post = Post.new(post_attribute)

                actual = post.is_characters_maximum_limit?

                expect(actual).to be_falsy   
            end
        end

        context "post text characters length is 1000" do
            it "return false" do
                text = 'o' * 1000
                post_attribute = {
                    "text" => text
                }
                post = Post.new(post_attribute)

                actual = post.is_characters_maximum_limit?

                expect(actual).to be_falsy   
            end
        end

        context "post text characters length is 1001" do
            it "return true" do
                text = 'o' * 1001
                post_attribute = {
                    "text" => text
                }
                post = Post.new(post_attribute)

                actual = post.is_characters_maximum_limit?

                expect(actual).to be_truthy   
            end
        end
    end

    describe "#save_by" do
        context "given mock_user" do
            it "should call mock_query and set_post_id" do
                mock_query = double
                mock_id = double
                mock_user = double
                post_attribute = {
                    "text" => "Hello world"
                }
                post = Post.new(post_attribute)
                allow(post).to receive(:get_insert_query_and_save_attachment_if_attached_by).with(mock_user).and_return(mock_query)
                expect(mock_client).to receive(:query).with(mock_query)
                allow(mock_client).to receive(:last_id).and_return(mock_id)

                post.save_by(mock_user)

                expect(post.id).to eq(mock_id)  
            end
        end
    end

    describe "#save_hashtags" do
        it "should call post_with_id" do
            hashtag_text = double
            hashtag_texts = [hashtag_text]
            hashtag = double

            allow(Hashtag).to receive(:get_hashtags_by_text).with(post_valid_attribute_with_id["text"]).and_return(hashtag_texts)
            allow(Hashtag).to receive(:new).with(hashtag_text).and_return(hashtag)
            expect(hashtag).to receive(:save_on).with(post_with_id)

            post_with_id.save_hashtags
        end
    end

    describe ".get_insert_query_and_save_attachment_if_attached_by" do
        context "post have attachment" do
            it "should to equal expected" do
                attachment_attribute = {
                    "filename" => "filename", 
                    "tempfile" => "tempfile"
                }
                attachment = Attachment.new(attachment_attribute)
                post_attribute = {
                    "text" => "Hello world",
                    "attachment" => attachment
                }
                post = Post.new(post_attribute)
                attachment_path = "/public/#{attachment.filename}"
                
                expected = "insert into posts (user_id, text, attachment_path) values ('#{user_with_id.id}','#{post.text}', '#{attachment_path}')"
                
                allow(attachment).to receive(:save)
                actual = post.get_insert_query_and_save_attachment_if_attached_by(user_with_id)

                expect(actual).to eq(expected)
            end
        end

        context "post don't attachment" do
            it "should to equal expected" do
                post_attribute = {
                    "text" => "Hello world",
                    "user" => user_with_id
                }
                post = Post.new(post_attribute)
                expected = "insert into posts (user_id, text) values ('#{user_with_id.id}','#{post.text}')"
                
                actual = post.get_insert_query_and_save_attachment_if_attached_by(user_with_id)

                expect(actual).to eq(expected)
            end
        end
    end

    describe ".get_by_id" do
        context "given id is 1" do
            it "should call get_by_id_query with id equal 1, get post with id and name same with post_valid_attribute_with_id" do
                id = "1"
                get_by_id_query = "select * from posts where id = #{id}"
                rawData = [post_valid_attribute_with_id]                

                expect(mock_client).to receive(:query).with(get_by_id_query).and_return(rawData)

                post = Post.get_by_id(id)

                expect(post.id).to eq(id)
                expect(post.text).to eq(post_valid_attribute_with_id["text"])
            end
        end
    end

    describe ".fetch_by_hashtag_text" do
        context "given monday" do
            it "should call fetch_by_hashtag_text_query and first posts(id and text) to equal post_with_id_text_contain_hashtag" do
                hashtag_text = "monday"
                fetch_by_hashtag_text_query = "select * from posts where text like '%#{hashtag_text}%'"
                rawData = [post_valid_attribute_with_id_text_contain_hashtag]                

                expect(mock_client).to receive(:query).with(fetch_by_hashtag_text_query).and_return(rawData)

                posts = Post.fetch_by_hashtag_text(hashtag_text)

                expect(posts.first.id).to eq(post_with_id_text_contain_hashtag.id)
                expect(posts.first.text).to eq(post_with_id_text_contain_hashtag.text)
            end
        end
    end
    
    describe "#set_attachment" do
        context "given mock_attachment" do
            it "should post(attachment) to equal mock_attachment" do
                mock_attachment = double

                post.set_attachment(mock_attachment)

                expect(post.attachment).to eq(mock_attachment)
            end
        end
    end
    
end
