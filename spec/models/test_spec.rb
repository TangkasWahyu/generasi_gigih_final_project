require_relative '../test_helper'
require_relative '../../models/text'

describe Text do
    describe ".initialize" do
        context "given valid attribute" do
            it "should create object that equal with valid_attribute" do
                valid_attribute = {
                    "text" => "Hello world"
                }

                hello_world_post = Text.new(valid_attribute)

                expect(hello_world_post.text).to  eq(valid_attribute["text"])
            end
        end
    end
    
    describe "#save_hashtags" do
        context "post_attribute contain 1 hashtag" do
            it "should call hashtags and insert_post_hashtags_query" do
                post_attribute = {
                    "id" => "1",
                    "text" => "Hello world #monday"
                }
                hashtags = ["monday"]
                post = Text.new(post_attribute)
                hashtag_ids = ["1"]
                mock_client = double
                insert_post_hashtags_query = "insert into postHashtags (post_id, hashtag_id) values (#{post.id}, #{hashtag_ids[0]})"
                
                allow(post).to receive(:get_hashtags).and_return(hashtags)
                expect(Hashtag).to receive(:save_hashtags).with(hashtags).and_return(hashtag_ids)
                allow(Mysql2::Client).to receive(:new).and_return(mock_client)
                expect(mock_client).to receive(:query).with(insert_post_hashtags_query)
    
                post.save_hashtags
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
                post = Text.new(valid_post_attribute_with_1_hashtag)

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
                post = Text.new(valid_post_attribute_without_hashtag)

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
                post = Text.new(valid_post_attribute_with_1_uppercase_hashtag)

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
                post = Text.new(valid_post_attribute_with_2_hashtag)

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
                post = Text.new(valid_post_attribute_with_2_same_hashtag)

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
                post = Text.new(post_attribute)

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
                post = Text.new(post_attribute)

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
                post = Text.new(post_attribute)

                actual = post.is_characters_maximum_limit?

                expect(actual).to be_truthy   
            end
        end
    end

    describe "#sent" do
        # context "when user post with hello_world_post" do
        #     it "should call insert_post_query and return 1" do
        #         hello_world_attribute = {
        #             "text" => "Hello world"
        #         }
        #         hello_world_post = Post.new(hello_world_attribute)
        #         user_with_post_attribute = {
        #             "id" => "1",
        #             "username" => "mark",
        #             "email" => "mark@mail.com",
        #             "bio_description" => "20 years old and grow",
        #             "post" => hello_world_post
        #         }
                
        #         user_with_post = User.new(user_with_post_attribute)
        #         insert_post_query = "insert into posts (user_id, text) values ('#{user_valid_attribute["id"]}','#{hello_world_attribute["text"]}')"

        #         expect(mock_client).to receive(:query).with(insert_post_query)
        #         allow(mock_client).to receive(:last_id).and_return(1)

        #         actual = user_with_post.sent_text
        #     end
        # end
    end
end
