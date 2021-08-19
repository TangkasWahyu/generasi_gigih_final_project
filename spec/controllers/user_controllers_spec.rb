require_relative '../test_helper'
require_relative '../../controllers/user_controller'
require_relative '../../models/user'
require_relative '../../models/comment'
require_relative '../../models/attachment'

describe UserController do
    let(:user_mock) { double }
    let(:post_mock) { double }
    let(:user_id) { "1" }
    let(:text) { "Hello world" }

    describe ".save" do
        context "given user attribute" do
            let(:user_attribute) {{
                "username" => "mark",
                "email" => "mark@mail.com",
                "bio" => "20 years old and always grow"
            }}

            before(:each) do
                allow(User).to receive(:new).and_return(user_mock)
                allow(user_mock).to receive(:save)
            end

            it "does save user" do
                expect(user_mock).to receive(:save) 

                UserController.save(user_attribute)
            end
        end
    end

    describe ".post" do
        let(:post_attribute) {{ "text" => text }}
        let(:post_mock) { double } 
        let(:valid_parameter) {{
            "id" => user_id,
            "text" => text
        }} 

        before(:each) do
            allow(User).to receive(:fetch_by_id).and_return(user_mock)
            allow(Post).to receive(:new).and_return(post_mock)
            allow(user_mock).to receive(:send)
        end

        context "given valid parameter" do
            it "does send post" do
                expect(user_mock).to receive(:send).with(post_mock)

                UserController.post(valid_parameter)
            end
        end

        context "given valid parameter with attachment" do
            let(:attachment_attribute_mock) { double } 
            let(:attachment_mock) { double } 
            let(:valid_parameter_with_attachment) {{
                **valid_parameter,
                "attachment" => attachment_attribute_mock
            }} 

            before(:each) do
                allow(Attachment).to receive(:new).and_return(attachment_mock)
                allow(post_mock).to receive(:set_attachment)
            end

            it "does fetch user by id" do
                expect(User).to receive(:fetch_by_id).with(user_id)

                UserController.post(valid_parameter_with_attachment)
            end

            it "does create post" do
                expect(Post).to receive(:new).with(post_attribute)

                UserController.post(valid_parameter_with_attachment)
            end

            it "does create attachment" do
                expect(Attachment).to receive(:new).with(attachment_attribute_mock)

                UserController.post(valid_parameter_with_attachment)
            end

            it "does set attachment on post" do
                expect(post_mock).to receive(:set_attachment).with(attachment_mock)

                UserController.post(valid_parameter_with_attachment)
            end
            
            it "does send post" do
                expect(user_mock).to receive(:send).with(post_mock)

                UserController.post(valid_parameter_with_attachment)
            end
        end
    end

    describe ".comment" do
        let(:post_mock) { double } 
        let(:comment_mock) { double }
        let(:user_have_post_mock) { double }
        let(:post_id) { "1" }
        let(:comment_attribute) {{ "text" => text }}
        let(:valid_parameter) {{
            "user_id" => user_id,
            "post_id" => post_id,
            "text" => text
        }} 

        before(:each) do
            allow(User).to receive(:fetch_by_id).and_return(user_mock)
            allow(Post).to receive(:fetch_by_id).and_return(post_mock)
            allow(Comment).to receive(:new).and_return(comment_mock)
            allow(user_mock).to receive(:on).and_return(user_have_post_mock)
            allow(user_have_post_mock).to receive(:send)
        end

        context "given valid parameter" do
            it "does fetch user by id" do
                expect(User).to receive(:fetch_by_id).with(user_id)

                UserController.comment(valid_parameter)
            end

            it "does fetch post by id" do
                expect(Post).to receive(:fetch_by_id).with(post_id)

                UserController.comment(valid_parameter)
            end

            it "does create comment" do
                expect(Comment).to receive(:new).with(comment_attribute)

                UserController.comment(valid_parameter)
            end

            it "does send comment on post" do
                expect(user_mock).to receive(:on).with(post_mock)
                expect(user_have_post_mock).to receive(:send).with(comment_mock)

                UserController.comment(valid_parameter)
            end
        end

        context "given valid parameter with attachment" do
            let(:attachment_attribute_mock) { double } 
            let(:attachment_mock) { double } 
            let(:valid_parameter_with_attachment) {{
                **valid_parameter,
                "attachment" => attachment_attribute_mock
            }} 

            before(:each) do
                allow(Attachment).to receive(:new).and_return(attachment_mock)
                allow(comment_mock).to receive(:set_attachment)
            end

            it "does fetch user by id" do
                expect(User).to receive(:fetch_by_id).with(user_id)

                UserController.comment(valid_parameter_with_attachment)
            end

            it "does fetch post by id" do
                expect(Post).to receive(:fetch_by_id).with(post_id)

                UserController.comment(valid_parameter_with_attachment)
            end

            it "does create comment" do
                expect(Comment).to receive(:new).with(comment_attribute)

                UserController.comment(valid_parameter_with_attachment)
            end

            it "does set attachment on post" do
                expect(comment_mock).to receive(:set_attachment).with(attachment_mock)

                UserController.comment(valid_parameter_with_attachment)
            end

            it "does send comment on post" do
                expect(user_mock).to receive(:on).with(post_mock)
                expect(user_have_post_mock).to receive(:send).with(comment_mock)

                UserController.comment(valid_parameter_with_attachment)
            end
        end
    end
end
