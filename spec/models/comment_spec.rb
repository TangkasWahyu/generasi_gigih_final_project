require_relative '../test_helper'
require_relative '../../models/user'
require_relative '../../models/comment'
require_relative '../../models/post'
require_relative '../../models/attachment'

describe Comment do
    describe ".save_ref" do
        context "given mock_user" do
          it "should call insert_query" do
				mock_user = double
				mock_post = double
				mock_post_id = double
				mock_client = double
				comment_attribute = {
					"text" => "Hello world"
				}
				comment = Comment.new(comment_attribute)
				insert_post_ref_query = "insert into postRefs (post_id, post_ref_id) values (#{@id}, #{mock_post_id})"

				allow(mock_user).to receive(:post).and_return(mock_post)
				allow(mock_post).to receive(:id).and_return(mock_post_id)
				allow(Mysql2::Client).to receive(:new).and_return(mock_client)
				expect(mock_client).to receive(:query).and_return(mock_client)

				comment.save_ref(mock_user)
          end
        end
    end
end
