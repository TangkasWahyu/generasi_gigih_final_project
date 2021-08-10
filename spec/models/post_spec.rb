require_relative '../test_helper'
require_relative '../../models/post'

describe Post do
    describe ".initialize" do
        context "given valid attribute" do
            it "should create object that equal with valid_attribute" do
                valid_attribute = {
                    "text" => "Hello world"
                }

                hello_world_post = Post.new(valid_attribute)

                expect(hello_world_post.text).to  eq(valid_attribute["text"])
            end
        end
    end
    
    describe "#save_hashtags" do
        it "should call method get_hashtags with hashtags param and call method save_hashtags" do
            valid_attribute = {
                "text" => "Hello world #monday"
            }
            hashtags = ["monday"]
            hello_world_post = Post.new(valid_attribute)
            
            expect(hello_world_post).to receive(:get_hashtags).and_return(hashtags)
            expect(Hashtag).to receive(:save_hashtags).with(hashtags)

            hello_world_post.save_hashtags
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
end
