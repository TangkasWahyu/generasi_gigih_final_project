require_relative '../../controllers/post_controller'
require_relative '../../models/post'

describe PostController do
	describe ".get_by_hashtag" do
		context "given valid params hash that contain hashtag_id key" do
			it "should call hashtag_id value" do
				hashtag_id = "1"
				valid_params = {
					"hashtag_id" => hashtag_id
				}

				expect(Post).to receive(:fetch_by_hashtag).with(hashtag_id)

				PostController.get_by_hashtag(valid_params)
			end
        end
    end
end
