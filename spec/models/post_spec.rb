require_relative '../test_helper'
require_relative '../../models/post'
require_relative '../../models/attachment'

describe Post do
    let(:text){ "Hello world" }
    let(:post_attribute) {{
        "text" => text
    }}
    let(:mock_client) {double}

    before(:each) do
        allow(Mysql2::Client).to receive(:new).and_return(mock_client)
    end

    describe "#initialize" do
        context "given post attribute" do
            let(:post) { Post.new(post_attribute) } 

            it "should create object(text) to equal post attribute(text)" do
                expect(post.text).to eq(post_attribute["text"])
            end
        end
    end

    describe "#send_by" do
        context "given mock_user" do
            let(:mock_user) { double }
            let(:post) { Post.new post_attribute }
            let(:last_id) { double }
            let(:user_id) { double }
            let(:insert_post_query) { "insert into posts (user_id, text) values ('#{user_id}','#{text}')" }

            before(:each) do
                allow(mock_client).to receive(:last_id).and_return(last_id)
                allow(mock_user).to receive(:id).and_return(user_id)
                allow(mock_client).to receive(:query)
            end

            context "text character is not limit" do
                it "does save" do
                    expect(mock_client).to receive(:query).with(insert_post_query)
        
                    post.send_by(mock_user)
                end
                
                context "text characters length is 1000" do
                    let(:text) { 'o' * 1000 }
                    let(:post_attribute) {{ "text" => text }}
                    let(:post) { Post.new post_attribute }
        
                    it "does save" do
                        expect(mock_client).to receive(:query).with(insert_post_query)
            
                        post.send_by(mock_user)  
                    end
                end

                context "have hashtag" do
                    let(:hashtag_text) { double }
                    let(:hashtag_texts) { [hashtag_text] }
                    let(:hashtag) { double }
                    let(:text_contain_hashtag) { "hello world #monday" }
                    let(:post_with_text_contain_hashtag_attribute) {{
                        "user" => mock_user,
                        "text" => text_contain_hashtag
                    }}
                    let(:post_have_id_text_contain_hashtag) { Post.new post_with_text_contain_hashtag_attribute }
            
                    before(:each) do
                        allow(Hashtag).to receive(:get_hashtags_by_text).and_return(hashtag_texts)
                        allow(Hashtag).to receive(:new).and_return(hashtag)
                        allow(hashtag).to receive(:save_on)
                    end
        
                    it "does save hashtags" do
                        expect(hashtag).to receive(:save_on).with(post_have_id_text_contain_hashtag)
            
                        post_have_id_text_contain_hashtag.send_by(mock_user)
                    end
                end

                context "text don't have hashtag" do
                    before(:each) do
                        allow(Hashtag).to receive(:contained?).and_return(false)
                    end
        
                    it "does not save hashtags" do
                        expect(post).to_not receive(:save_hashtags)
            
                        post.send_by(mock_user)
                    end
                end

                context "have attachment" do
                    let(:mock_attachment) { double }
                    let(:mock_saved_filename) { double }
                    let(:post_with_attachment_attribute) {{
                        **post_attribute,
                        "attachment" => mock_attachment,
                    }}
                    let(:post_have_attachment) { Post.new post_with_attachment_attribute }
        
                    before(:each) do
                        allow(mock_attachment).to receive(:attached_by)
                        allow(mock_attachment).to receive(:saved_filename).and_return(mock_saved_filename)
                    end
        
                    it "does save with attachment path" do
                        expected = "insert into posts (user_id, text, attachment_path) values ('#{user_id}','#{text}', '#{mock_saved_filename}')"
                        
                        expect(mock_client).to receive(:query).with(expected)
        
                        post_have_attachment.send_by(mock_user)
                    end
                end
            end
    
            context "text characters length is 1001" do
                let(:text) { 'o' * 1001 }
                let(:post_attribute) {{ "text" => text }}
                let(:post) { Post.new post_attribute }
    
                it "does not save" do
                    expect(mock_client).not_to receive(:query).with(insert_post_query)
        
                    post.send_by(mock_user)  
                end
            end
        end
    end
    
    describe "#set_attachment" do
        context "given mock_attachment" do
            let(:post) { Post.new post_attribute }

            it "does have attachment to equal mock_attachment" do
                mock_attachment = double

                post.set_attachment(mock_attachment)

                expect(post.attachment).to eq(mock_attachment)
            end
        end
    end

    describe ".fetch_by_id" do
        context "given id" do
            let(:id) { "1" }
            let(:text_contain_hashtag) { "hello world #monday" }
            let(:post_with_id_attribute) {{
                "id" => id,
                "text" => text_contain_hashtag
            }}
            let(:post_with_id) { Post.new post_with_id_attribute }
            let(:rawData) { [post_with_id_attribute] }

            before(:each) do
                allow(mock_client).to receive(:query).and_return(rawData)
            end

            it "does get post(id, name) to equal with post_valid_attribute_with_id" do
                post = Post.fetch_by_id(id)

                expect(post.id).to eq(id)
                expect(post.text).to eq(post_with_id_attribute["text"])
            end
        end
    end

    describe ".fetch_by_hashtag_text" do
        context "given hashtag text" do
            let(:hashtag_text) { "monday" }
            let(:text_contain_hashtag) { "hello world #monday" }
            let(:post_with_id_text_contain_hashtag_attribute) {{
                "id" => double,
                "text" => text_contain_hashtag
            }}
            let(:rawData) { [post_with_id_text_contain_hashtag_attribute] }
            let(:post_have_id_text_contain_hashtag) { Post.new post_with_id_text_contain_hashtag_attribute }

            before(:each) do
                allow(mock_client).to receive(:query).and_return(rawData)
            end

            it "does get first posts(id and text) to equal post_have_id_text_contain_hashtag" do
                posts = Post.fetch_by_hashtag_text(hashtag_text)
                
                expect(posts.first.id).to eq(post_have_id_text_contain_hashtag.id)
                expect(posts.first.text).to eq(post_have_id_text_contain_hashtag.text)
            end
        end
    end
end
