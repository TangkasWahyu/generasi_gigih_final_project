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
            
            expect(Post).to receive(:get_hashtags).and_return(hashtags)
            expect(Hashtag).to receive(:save_hashtags).with(hashtags)

            hello_world_post.save_hashtags
        end
    end
    
end
