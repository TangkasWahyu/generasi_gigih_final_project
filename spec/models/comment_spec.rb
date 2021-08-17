require_relative '../test_helper'
require_relative '../../models/user'
require_relative '../../models/comment'
require_relative '../../models/post'

describe Comment do
    describe "#save" do
		context "have user with id and post" do
			let(:id) { double }
			let(:post_valid_attribute_with_id) {{
				"id" => id,
				"text" => double
			}}
			let(:post_with_id) { Post.new post_valid_attribute_with_id }
			let(:user_attribute_with_id_and_post) {{
				"id" => "1",
				"username" => "mark",
				"email" => "mark@mail.com",
				"bio_description" => "20 years old and grow",
				"post" => post_with_id
			}}
			let(:user_with_id_and_post) { User.new user_attribute_with_id_and_post }
			let(:comment_attribute) {{
				"id" => id,
				"text" => double,
				"user" => user_with_id_and_post
			}}
			let(:comment) { Comment.new comment_attribute }
		
			it "should call mock_query and insert_post_ref_query" do
				mock_client = double
				mock_query = double
				insert_post_ref_query = "insert into postRefs (post_id, post_ref_id) values (#{id}, #{user_with_id_and_post.post.id})"

				allow(Mysql2::Client).to receive(:new).and_return(mock_client)
				allow(comment).to receive(:get_insert_query).and_return(mock_query)
				expect(mock_client).to receive(:query).with(mock_query)
				allow(mock_client).to receive(:last_id).and_return(id)
				expect(mock_client).to receive(:query).with(insert_post_ref_query)

				comment.save
			end
		end
    end
end
