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
end
