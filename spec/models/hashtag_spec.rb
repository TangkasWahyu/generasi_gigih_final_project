require_relative '../test_helper'
require_relative '../../models/hashtag'

describe Hashtag do
    describe "#initialize" do
        context "given monday text" do
            it "should create object.text that equal with monday text" do
                text = "monday"
                
                expected = Hashtag.new(text)

                expect(expected.text).to eq(text)
            end
        end
    end

    describe "#save_on" do
        context "given mock_post" do
            it "should call insert_query" do
                mock_client = double
                mock_last_id = double
                mock_post = double
                mock_post_id = double
                text = "monday"
                hashtag = Hashtag.new(text)
                insert_hashtag_query = "insert into hashtags (text, post_id) values ('#{text}', #{mock_last_id})"
    
                allow(Mysql2::Client).to receive(:new).and_return(mock_client)
                allow(mock_post).to receive(:id).and_return(mock_post_id)
                expect(mock_client).to receive(:query).with(insert_hashtag_query)
                allow(mock_client).to receive(:last_id).and_return(mock_last_id)

                hashtag.save_on(mock_post)
            end
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
            get_trending_24_hours_query = "select hashtags.text, count(hashtags.text) as total from posts left join hashtags on hashtags.post_id = posts.id where date >= DATE_SUB(NOW(), INTERVAL 1 DAY) group by hashtags.text order by total desc limit 5;"

            allow(Mysql2::Client).to receive(:new).and_return(mock_client)
            expect(mock_client).to receive(:query).with(get_trending_24_hours_query).and_return(mock_trending_hashtags)
            allow(mock_hashtag).to receive(:[]).and_return("text")
            allow(Hashtag).to receive(:new).and_return(mock_hashtag)

            Hashtag.get_trending
        end
    end
    
end
