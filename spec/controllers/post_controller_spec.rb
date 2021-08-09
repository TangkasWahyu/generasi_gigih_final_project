require_relative '../../controllers/post_controller'
require_relative '../../models/post'

describe PostController do
    describe ".save" do
        context "given valid parameter" do
            it "should call valid_parameter and save the post" do
                post_mock = double
                valid_parameter = {
                    "user_id" => "1",
                    "text" => "Hello world"
                }
                
                expect(Post).to receive(:new).with(valid_parameter).and_return(post_mock)
                expect(post_mock).to receive(:save) 

                PostController.save(valid_parameter)
            end
        end
    end
    
end
