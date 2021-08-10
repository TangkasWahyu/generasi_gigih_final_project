require_relative '../../controllers/user_controller'
require_relative '../../models/user'

describe UserController do
    describe ".save" do
        context "given valid parameter" do
            it "should call valid_parameter and save the user" do
                user_mock = double
                valid_parameter = {
                    "username" => "mark",
                    "email" => "mark@mail.com",
                    "bio" => "20 years old and always grow"
                }
                
                expect(User).to receive(:new).with(valid_parameter).and_return(user_mock)
                expect(user_mock).to receive(:save) 

                UserController.save(valid_parameter)
            end
        end
    end

    describe ".post" do
        context "given valid_parameter" do
            it "should call valid_parameter with user_id and text key and call post_mock" do
                user_mock = double
                post_mock = double
                valid_parameter = {
                    "id" => "1",
                    "text" => "Hello world"
                }

                expect(User).to receive(:get_by_id).with(valid_parameter["id"]).and_return(user_mock)
                expect(Post).to receive(:new).with(valid_parameter["text"]).and_return(post_mock)
                expect(user_mock).to receive(:post).with(post_mock)

                UserController.post(valid_parameter)
            end
        end
    end
end
