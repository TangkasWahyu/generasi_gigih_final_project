require_relative '../../controllers/post_controller'
require_relative '../../models/post'

describe PostController do
	describe ".get_by_hashtag" do
		context "given valid params hash that contain hashtag_text key" do
			it "should call hashtag_text value" do
				hashtag_text = "#monday"
				valid_params = {
					"hashtag_text" => hashtag_text
				}

				expect(Post).to receive(:fetch_by_hashtag).with(hashtag_text)

				PostController.get_by_hashtag(valid_params)
			end
        end
    end
end
