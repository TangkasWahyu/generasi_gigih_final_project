require_relative '../test_helper'
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
            it "should call user_id, post_attribute" do
                user_mock = double
                post_mock = double
                user_id = "1"
                text = "Hello world"
                valid_parameter = {
                    "id" => user_id,
                    "text" => text
                }
                post_attribute = {
                    "text" => text
                }

                expect(User).to receive(:get_by_id).with(user_id).and_return(user_mock)
                expect(Post).to receive(:new).with(post_attribute).and_return(post_mock)
                allow(user_mock).to receive(:add_post).with(post_mock)
                allow(user_mock).to receive(:post)

                UserController.post(valid_parameter)
            end
        end
    end

    describe ".comment" do
        context "given valid params" do
            it "should call user_id_and_post_text" do
                params = {
                    "user_id" => "1",
                    "post_id" => "1",
                    "text" => "comment"
                }
                user_id_and_post_text = {
                    "id" => "1",
                    "text" => "comment"
                }
                post_mock = double
                post_id_mock = double

                expect(UserController).to receive(:post).with(user_id_and_post_text).and_return(post_id_mock)
                allow(Post).to receive(:get_by_id).and_return(post_mock)
                allow(post_mock).to receive(:save_comment).with(post_id_mock)

                UserController.comment(params)
            end
        end
    end
end
