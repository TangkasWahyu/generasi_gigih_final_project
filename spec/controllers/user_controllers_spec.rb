require_relative '../test_helper'
require_relative '../../controllers/user_controller'
require_relative '../../models/user'
require_relative '../../models/comment'
require_relative '../../models/attachment'

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
                allow(user_mock).to receive(:send).with(post_mock)

                UserController.post(valid_parameter)
            end
        end

        context "given valid_parameter_with_attachment" do
            it "should call user_id, post_attribute, attachment_attribute_mock" do
                attachment_attribute_mock = double
                attachment_mock = double
                user_mock = double
                post_mock = double
                user_id = "1"
                text = "Hello world"
                valid_parameter_with_attachment = {
                    "id" => user_id,
                    "text" => text,
                    "attachment" => attachment_attribute_mock
                }
                post_attribute = {
                    "text" => text
                }

                expect(User).to receive(:get_by_id).with(user_id).and_return(user_mock)
                expect(Post).to receive(:new).with(post_attribute).and_return(post_mock)
                expect(Attachment).to receive(:new).with(attachment_attribute_mock).and_return(attachment_mock)
                allow(post_mock).to receive(:set_attachment).with(attachment_mock)
                allow(user_mock).to receive(:send).with(post_mock)

                UserController.post(valid_parameter_with_attachment)
            end
        end
    end

    describe ".comment" do
        context "given valid params" do
            it "should call user_id, post_id, comment_attribute" do
                user_id = 1
                post_id = 1
                text = "comment"
                params = {
                    "user_id" => user_id,
                    "post_id" => post_id,
                    "text" => text
                }
                comment_attribute = {
                    "text" => text
                }

                post_mock = double
                user_mock = double
                post_id_mock = double
                comment_mock = double

                expect(User).to receive(:get_by_id).with(user_id).and_return(user_mock)
                expect(Post).to receive(:get_by_id).with(post_id).and_return(post_mock)
                expect(Comment).to receive(:new).with(comment_attribute).and_return(comment_mock)
                allow(user_mock).to receive(:on).with(post_mock).and_return(user_mock)
                allow(user_mock).to receive(:send).with(comment_mock)

                UserController.comment(params)
            end
        end

        context "given valid_parameter_with_attachment" do
            it "should call user_id, post_id, comment_attribute and attachment_attribute_mock" do
                attachment_attribute_mock = double
                attachment_mock = double
                user_mock = double
                post_mock = double
                comment_mock = double
                user_id = "1"
                post_id = "1"
                text = "comment"
                valid_parameter_with_attachment = {
                    "user_id" => user_id,
                    "text" => text,
                    "post_id" => post_id,
                    "attachment" => attachment_attribute_mock
                }
                comment_attribute = {
                    "text" => text
                }

                expect(User).to receive(:get_by_id).with(user_id).and_return(user_mock)
                expect(Post).to receive(:get_by_id).with(post_id).and_return(post_mock)
                expect(Comment).to receive(:new).with(comment_attribute).and_return(comment_mock)
                expect(Attachment).to receive(:new).with(attachment_attribute_mock).and_return(attachment_mock)
                allow(comment_mock).to receive(:set_attachment).with(attachment_mock)
                allow(user_mock).to receive(:on).with(post_mock).and_return(user_mock)
                allow(user_mock).to receive(:send).with(comment_mock)

                UserController.comment(valid_parameter_with_attachment)
            end
        end
    end
end
