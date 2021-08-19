require_relative '../test_helper'
require_relative '../../models/hashtag'
require_relative '../../models/post'

describe Hashtag do
    describe "#initialize" do
        context "given monday" do
            let(:actual) { Hashtag.new("monday") } 

            it "does create object(text) to equal monday" do
                expect(actual.text).to eq("monday")
            end
        end
    end

    describe "#save_on" do
        context "given post" do
            let(:post_text){ "Hello world? #monday" }
			let(:post_id) { "1" } 
			let(:post_attribute) {{
				"text" => post_text,
                "id" => post_id
			}}
            let(:post) { Post.new post_attribute }

            let(:text) { "monday" }
            let(:hashtag) { Hashtag.new text }

			let(:mock_client) { double } 
			let(:mock_last_id) { double } 
            let(:insert_hashtag_query) { "insert into hashtags (text, post_id) values ('#{text}', #{post_id})" }

            before(:each) do
                allow(Mysql2::Client).to receive(:new).and_return(mock_client)
                allow(mock_client).to receive(:last_id).and_return(mock_last_id)
            end

            it "does save hashtag" do
                expect(mock_client).to receive(:query).with(insert_hashtag_query)

                hashtag.save_on(post)
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

    describe ".fetch_trending" do
        it "should call fetch_trending_24_hours_query" do
            mock_client = double
            mock_hashtag = double
            mock_trending_hashtags = [mock_hashtag, mock_hashtag, mock_hashtag]
            fetch_trending_24_hours_query = "select hashtags.text, count(hashtags.text) as total from posts left join hashtags on hashtags.post_id = posts.id where date >= DATE_SUB(NOW(), INTERVAL 1 DAY) group by hashtags.text order by total desc limit 5;"

            allow(Mysql2::Client).to receive(:new).and_return(mock_client)
            expect(mock_client).to receive(:query).with(fetch_trending_24_hours_query).and_return(mock_trending_hashtags)
            allow(mock_hashtag).to receive(:[]).and_return("text")
            allow(Hashtag).to receive(:new).and_return(mock_hashtag)

            Hashtag.fetch_trending
        end
    end
    
end
