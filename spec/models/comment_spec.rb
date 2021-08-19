require_relative '../test_helper'
require_relative '../../models/comment'

describe Comment do
    describe "#send_by" do
		context "given mock user" do
			let(:id) { double } 
			let(:mock_user) { double }
            let(:mock_user_id) { double }
			let(:mock_post) { double } 
			let(:post_id) { double } 
			let(:mock_client) { double } 
			let(:last_id) { double }
			let(:text){ "Hello world" }
			let(:comment_attribute) {{
				"id" => id,
				"text" => text,
				"user" => mock_user
			}}
			let(:comment) { Comment.new comment_attribute } 
            let(:insert_post_query) { "insert into posts (user_id, text) values ('#{mock_user_id}','#{text}')" }
            let(:insert_post_ref_query) { "insert into postRefs (post_id, post_ref_id) values (#{id}, #{post_id})" }

			before(:each) do
				allow(Mysql2::Client).to receive(:new).and_return(mock_client)
                allow(mock_user).to receive(:post).and_return(mock_post)
                allow(mock_post).to receive(:id).and_return(post_id)
                allow(mock_client).to receive(:last_id).and_return(last_id)
                allow(mock_user).to receive(:id).and_return(mock_user_id)
                allow(mock_client).to receive(:query)
			end
		
			it "does save comment" do
				expect(mock_client).to receive(:query).with(insert_post_query)
				expect(mock_client).to receive(:query).with(insert_post_ref_query)

				comment.send_by(mock_user)
			end
		end
    end
end
