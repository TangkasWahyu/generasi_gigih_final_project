require_relative '../test_helper'
require_relative '../../controllers/hashtag_controller'

describe HashtagController do
    describe ".get_trending" do
        it "return top_5_hashtags_24_hours" do
            top_5_hashtags_24_hours = ["monday", "tuesday", "wednesday", "thursday", "friday"]

            allow(Hashtag).to receive(:fetch_trending).and_return(top_5_hashtags_24_hours)

            actual = HashtagController.get_trending

            expect(actual).to eq(top_5_hashtags_24_hours) 
        end
    end

    describe ".get_by_hashtag" do
		context "given valid params" do
            let(:hashtag_text){ "#monday" }
            let(:valid_params){{ "hashtag_text" => hashtag_text }}
            
			it "does fetch by hashtag text" do
				expect(Post).to receive(:fetch_by_hashtag_text).with(hashtag_text)

				HashtagController.get_by_hashtag_text(valid_params)
			end
        end
    end
end
