require_relative '../test_helper'
require_relative '../../models/comment'

describe Comment do
    describe "#save" do
		context "have user and user have post with id" do
			let(:id) { double } 
			let(:post_id) { double } 
			let(:mock_user) { double }
			let(:mock_query) { double } 
			let(:mock_client) { double } 
			let(:comment_attribute) {{
				"id" => id,
				"text" => double,
				"user" => mock_user
			}}
			let(:comment) { Comment.new comment_attribute } 

			before(:each) do
				allow(Mysql2::Client).to receive(:new).and_return(mock_client)
				allow(mock_user).to receive_message_chain(:post, :id).and_return(post_id)
				allow(comment).to receive(:get_insert_query).and_return(mock_query)
				allow(mock_client).to receive(:last_id).and_return(id)
				allow(Hashtag).to receive(:contained?)
			end
		
			it "does query with mock query and insert post ref query" do
				insert_post_ref_query = "insert into postRefs (post_id, post_ref_id) values (#{id}, #{post_id})"

				expect(mock_client).to receive(:query).with(mock_query)
				expect(mock_client).to receive(:query).with(insert_post_ref_query)

				comment.save
			end
		end
    end
end
