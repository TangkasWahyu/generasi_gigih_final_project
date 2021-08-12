require_relative '../test_helper'
require_relative '../../models/user'
require_relative '../../models/post'

describe Post do
    let(:post_valid_attribute) {{
        "text" => "Hello world"
    }}
    let(:post_valid_attribute_with_id) {{
        "id" => "1",
        "text" => "Hello world"
    }}
    let(:post) { Post.new post_valid_attribute }
    let(:post_with_id) { Post.new post_valid_attribute_with_id }
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
    
    describe "#save_hashtags" do
        context "post_attribute contain 1 hashtag" do
            it "should call hashtags and insert_post_hashtags_query" do
                hashtags = ["monday"]
                hashtag_ids = ["1"]
                insert_post_hashtags_query = "insert into postHashtags (post_id, hashtag_id) values (#{post_with_id.id}, #{hashtag_ids[0]})"
                
                allow(post_with_id).to receive(:get_hashtags).and_return(hashtags)
                expect(Hashtag).to receive(:save_hashtags).with(hashtags).and_return(hashtag_ids)
                expect(mock_client).to receive(:query).with(insert_post_hashtags_query)
    
                post_with_id.save_hashtags
            end
        end
    end
    
    describe "#get_hashtags" do
        context "post contain #monday" do
            it "return #monday" do
                expected = ["#monday"]
                valid_post_attribute_with_1_hashtag = {
                    "text" => "Hello world #monday"
                }
                post = Post.new(valid_post_attribute_with_1_hashtag)

                actual = post.get_hashtags

                expect(actual).to eq(expected)
            end
        end

        context "post contain no hashtag" do
            it "return empty array" do
                expected = []
                valid_post_attribute_without_hashtag = {
                    "text" => "Hello world"
                }
                post = Post.new(valid_post_attribute_without_hashtag)

                actual = post.get_hashtags

                expect(actual).to eq(expected)
            end
        end

        context "post contain #Monday" do
            it "return array that contain #monday only" do
                expected = ["#monday"]
                valid_post_attribute_with_1_uppercase_hashtag = {
                    "text" => "Hello world #Monday"
                }
                post = Post.new(valid_post_attribute_with_1_uppercase_hashtag)

                actual = post.get_hashtags

                expect(actual).to eq(expected)
            end
        end

        context "post contain #Monday and #tuesday" do
            it "return array that contain #monday and #tuesday only" do
                expected = ["#monday", "#tuesday"]
                valid_post_attribute_with_2_hashtag = {
                    "text" => "Hello world #monday #tuesday"
                }
                post = Post.new(valid_post_attribute_with_2_hashtag)

                actual = post.get_hashtags

                expect(actual).to eq(expected)
            end
        end

        context "post contain #monday and #monday" do
            it "return array that contain #monday only" do
                expected = ["#monday"]
                valid_post_attribute_with_2_same_hashtag = {
                    "text" => "Hello world #monday #monday"
                }
                post = Post.new(valid_post_attribute_with_2_same_hashtag)

                actual = post.get_hashtags

                expect(actual).to eq(expected)
            end
        end
    end
    
    describe "#is_characters_maximum_limit?" do
        context "when text characters length below 1000" do
            it "return false" do
                post_attribute = {
                    "text" => "Hello world #monday"
                }
                post = Post.new(post_attribute)

                actual = post.is_characters_maximum_limit?

                expect(actual).to be_falsy   
            end
        end

        context "when text characters length is 1000" do
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

        context "when text characters length is 1001" do
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

    describe "#send" do
        it "should call insert_post_query" do
            user_attribute = {
                "id" => "1",
                "username" => "mark",
                "email" => "mark@mail.com",
                "bio_description" => "20 years old and grow"
            }
            user = User.new(user_attribute)
            post_attribute = {
                "text" => "Hello world",
                "user" => user
            }
            post = Post.new(post_attribute)
            post_with_id = double
            post_id = 1
            
            insert_post_query = "insert into posts (user_id, text) values ('#{post.user.id}','#{post.text}')"
            
            expect(mock_client).to receive(:query).with(insert_post_query)
            allow(mock_client).to receive(:last_id).and_return(post_id)

            post.send
        end
    end

    describe "#add_user" do
        context "given user_mock" do
            it "should post.user equal user_mock" do
                user_mock = double

                post.add_user(user_mock)

                expect(post.user).to eq(user_mock)
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
end
