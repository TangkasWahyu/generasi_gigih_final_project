require_relative '../test_helper'
require_relative '../../models/hashtag'

describe Hashtag do
    describe ".save_hashtags" do
        context "given array that contain 2 hashtags" do
            it "should return array that contain 1 and 2 only" do
                hashtag_texts = ["#monday", "#tuesday"]
                hashtag = double

                allow(Hashtag).to receive(:new).with(hashtag_texts[0]).and_return(hashtag)
                allow(Hashtag).to receive(:new).with(hashtag_texts[1]).and_return(hashtag)
                allow(hashtag).to receive(:save).and_return("1", "2")

                actual = Hashtag.save_hashtags(hashtag_texts)

                expect(actual).to eq(["1", "2"])
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

    describe ".save" do
        it "should call insert_query and return '1'" do
            mock_client = double
            text = "monday"
            hashtag = Hashtag.new(text)
            insert_query = "insert into hashtags (text) values ('#{text}')"

            allow(Mysql2::Client).to receive(:new).and_return(mock_client)
            expect(mock_client).to receive(:query).with(insert_query)
            allow(mock_client).to receive(:last_id).and_return(1)

            actual = hashtag.save

            expect(actual).to eq('1')
        end
    end

    describe ".contained?" do
        context "given text contain #monday" do
            it "should return true" do
                text = "Hello world #monday"

                actual = Hashtag.contained?(text)

                expect(actual).to be_truthy 
            end
        end

        context "given text contain no hashtag" do
            it "should return false" do
                text = "Hello world"

                actual = Hashtag.contained?(text)

                expect(actual).to be_falsy
            end
        end
    end

    describe ".get_hashtags_by_text" do
        context "text contain #monday" do
            it "return #monday" do
                expected = ["#monday"]
                text = "Hello world #monday"

                actual = Hashtag.get_hashtags_by_text(text)

                expect(actual).to eq(expected)
            end
        end

        context "text contain no hashtag" do
            it "return empty array" do
                expected = []
                text = "Hello world"

                actual = Hashtag.get_hashtags_by_text(text)

                expect(actual).to eq(expected)
            end
        end

        context "text contain #Monday" do
            it "return array that contain #monday only" do
                expected = ["#monday"]
                text = "Hello world #Monday"

                actual = Hashtag.get_hashtags_by_text(text)

                expect(actual).to eq(expected)
            end
        end

        context "text contain #Monday and #tuesday" do
            it "return array that contain #monday and #tuesday only" do
                expected = ["#monday", "#tuesday"]
                text = "Hello world #monday #tuesday"
                
                actual = Hashtag.get_hashtags_by_text(text)

                expect(actual).to eq(expected)
            end
        end

        context "text contain #monday and #monday" do
            it "return array that contain #monday only" do
                expected = ["#monday"]
                text = "Hello world #monday #monday"

                actual = Hashtag.get_hashtags_by_text(text)

                expect(actual).to eq(expected)
            end
        end
    end

    describe ".trending" do
        it "should call get_trending_24_hours_query" do
            mock_client = double
            mock_hashtag = double
            mock_trending_hashtags = [mock_hashtag, mock_hashtag, mock_hashtag]
            get_trending_24_hours_query = "select text, COUNT(text) as total from ( select hashtags.text as 'text', posts.date as 'date' from hashtags join postHashtags on hashtags.id = postHashtags.hashtag_id join posts on postHashtags.post_id = posts.id union all select hashtags.text as 'text', comments.date as 'date' from hashtags join commentHashtags on hashtags.id = commentHashtags.hashtag_id join comments on commentHashtags.comment_id = comments.id )as postAndCommentHashtag where date >= DATE_SUB(NOW(), INTERVAL 1 DAY) group by text order by total desc limit 5;"

            allow(Mysql2::Client).to receive(:new).and_return(mock_client)
            expect(mock_client).to receive(:query).with(get_trending_24_hours_query).and_return(mock_trending_hashtags)
            allow(mock_hashtag).to receive(:[]).and_return("text")
            allow(Hashtag).to receive(:new).and_return(mock_hashtag)

            Hashtag.get_trending
        end
    end
    
end
