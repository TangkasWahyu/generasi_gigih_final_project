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
    
end
