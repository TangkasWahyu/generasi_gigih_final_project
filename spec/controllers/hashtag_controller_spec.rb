require_relative '../test_helper'
require_relative '../../controllers/hashtag_controller'

describe HashtagController do
    describe ".trending" do
        it "return top_5_hashtags_24_hours" do
            top_5_hashtags_24_hours = ["monday", "tuesday", "wednesday", "thursday", "friday"]

            allow(Hashtag).to receive(:get_trending).and_return(tot_5_hashtags_24_hours)

            actual = HashtagController.trending

            expect(actual).to eq(tot_5_hashtags_24_hours) 
        end
    end
end
