require_relative '../test_helper'
require_relative '../../controllers/hashtag_controller'

describe HashtagController do
    describe ".get_trending" do
        let(:trending_hashtags) { ["monday", "tuesday", "wednesday", "thursday", "friday"] }
        
        it "does get trending hashtags" do
            allow(Hashtag).to receive(:fetch_trending).and_return(trending_hashtags)

            actual = HashtagController.get_trending

            expect(actual).to eq(trending_hashtags) 
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
