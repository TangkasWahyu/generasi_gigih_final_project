require_relative '../../models/hashtag'

describe Hashtag do
    describe ".save_hashtags" do
        context "given array that contain 2 hashtags" do
            it "should call save method and new method 2 times" do
                hashtags = ["#monday", "#tuesday"]
                hashtag = double

                expect(Hashtag).to receive(:new).twice.and_return(hashtag)
                expect(hashtag).to receive(:save).twice

                Hashtag.save_hashtags(hashtags)
            end
        end
    end
    
    describe "#initialize" do
        context "given monday text" do
            it "should create object.text that equal with monday text" do
                text = "monday"
                
                expected = Hashtag.new(text)

                expect(expected.text).to eq(text)
            end
        end
    end
end
