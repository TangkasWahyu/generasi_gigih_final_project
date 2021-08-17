require_relative '../test_helper'
require_relative '../../models/post'
require_relative '../../models/attachment'

describe Post do
    let(:text){ "Hello world" }
    let(:text_contain_hashtag){ "Hello world #monday" }
    let(:mock_attachment){ double }
    let(:post_valid_attribute) {{
        "text" => text
    }}
    let(:post_valid_with_attachment_attribute) {{
        "text" => text,
        "attachment" => mock_attachment
    }}
    let(:post_valid_attribute_with_id) {{
        "id" => "1",
        "text" => text
    }}
    let(:post_valid_attribute_with_id_text_contain_hashtag) {{
        "id" => "1",
        "text" => text_contain_hashtag
    }}
    let(:post_with_attachment) { Post.new post_valid_with_attachment_attribute }
    let(:post) { Post.new post_valid_attribute }
    let(:post_with_id) { Post.new post_valid_attribute_with_id }
    let(:post_with_id_text_contain_hashtag) { Post.new post_valid_attribute_with_id_text_contain_hashtag }
    let(:mock_client) {double}

    before(:each) do
        allow(Mysql2::Client).to receive(:new).and_return(mock_client)
    end

    describe ".initialize" do
        context "given valid attribute" do
            it "should create object that equal with valid_attribute" do
                expect(post.text).to eq(post_valid_attribute["text"])
            end
        end
    end

    describe "#send_by" do
        context "given mock_user" do
            before(:each) do
                @mock_user = double
            end

            context "text character is not limit" do
                before(:each) do
                    allow(post).to receive(:is_characters_maximum_limit?).and_return(false)
                    allow(post).to receive(:save)
                end
                
                it "does have user to equal mock_user" do
                    post.send_by(@mock_user)

                    expect(post.user).to eq(@mock_user) 
                end 
    
                it "does save" do
                    expect(post).to receive(:save)
    
                    post.send_by(@mock_user)
                end 
            end

            context "text character is limit" do
                before(:each) do
                    allow(post).to receive(:is_characters_maximum_limit?).and_return(true)
                end
                
                it "does not have user" do
                    post.send_by(@mock_user)

                    expect(post.user).to be_nil
                end 
    
                it "does not save" do
                    expect(post).to_not receive(:save)
    
                    post.send_by(@mock_user)
                end 
            end
        end
    end

    describe "#is_characters_maximum_limit?" do
        context "have text characters length below 1000" do
            before(:each) do
                post_attribute = { "text" => "Hello world #monday" }
                @post = Post.new(post_attribute)
            end

            it "does return false" do
                actual = @post.is_characters_maximum_limit?

                expect(actual).to be_falsy   
            end
        end

        context "post text characters length is 1000" do
            before(:each) do
                text = 'o' * 1000
                post_attribute = { "text" => text }
                @post = Post.new(post_attribute)
            end

            it "does return false" do
                actual = post.is_characters_maximum_limit?

                expect(actual).to be_falsy   
            end
        end

        context "post text characters length is 1001" do
            before(:each) do
                text = 'o' * 1001
                post_attribute = { "text" => text }
                @post = Post.new(post_attribute)
            end

            it "does return true" do
                actual = @post.is_characters_maximum_limit?

                expect(actual).to be_truthy   
            end
        end
    end

    describe "#save" do
        before(:each) do
            @mock_query = double
            @last_id = double
            allow(post).to receive(:get_insert_query).and_return(@mock_query)
            allow(mock_client).to receive(:last_id).and_return(@last_id)
            allow(mock_client).to receive(:query)
        end

        it "does insert_query" do
            expect(mock_client).to receive(:query).with(@mock_query)

            post.save
        end

        it "does have id to equal last_id" do
            post.save

            expect(post.id).to eq(@last_id)
        end

        context "text have hashtag" do
            before(:each) do
                allow(Hashtag).to receive(:contained?).and_return(true)
            end

            it "does save hashtags" do
                expect(post).to receive(:save_hashtags)
    
                post.save
            end
        end

        context "text don't have hashtag" do
            before(:each) do
                allow(Hashtag).to receive(:contained?).and_return(false)
            end

            it "does not save hashtags" do
                expect(post).to_not receive(:save_hashtags)
    
                post.save
            end
        end
    end

    describe "#get_insert_query" do
        context "have user" do
            before(:each) do
                @mock_user = double
                @user_id = double

                allow(@mock_user).to receive(:id).and_return(@user_id)
            end

            context "have attachment" do
                before(:each) do
                    @mock_saved_filename = double
                    post_have_attachment_and_user_attribute = {
                        "text" => text,
                        "attachment" => mock_attachment,
                        "user" => @mock_user
                    }
                    @post_have_attachment_and_user = Post.new(post_have_attachment_and_user_attribute)

                    allow(mock_attachment).to receive(:save_by)
                    allow(mock_attachment).to receive(:saved_filename).and_return(@mock_saved_filename)
                end

                it "does save attachment with mock user" do
                    expect(mock_attachment).to receive(:save_by).with(@mock_user)

                    @post_have_attachment_and_user.get_insert_query
                end

                it "get insert_query_with_attachment" do
                    expected = "insert into posts (user_id, text, attachment_path) values ('#{@user_id}','#{text}', '#{@mock_saved_filename}')"
                    
                    actual = @post_have_attachment_and_user.get_insert_query
    
                    expect(actual).to eq(expected)  
                end
            end
    
            context "does not have attachment" do
                before(:each) do
                    post_attribute_and_user_attribute = {
                        "text" => text,
                        "user" => @mock_user
                    }
                    @post_attribute_and_user = Post.new(post_attribute_and_user_attribute)
                end

                it "does get insert_query" do
                    expected = "insert into posts (user_id, text) values ('#{@user_id}','#{text}')"
                    
                    actual = @post_attribute_and_user.get_insert_query
    
                    expect(actual).to eq(expected)  
                end
            end
        end
    end
    
    describe "#is_attached?" do
        context "have attachment" do
            it "does return true" do
                actual = post_with_attachment.is_attached?

                expect(actual).to be_truthy
            end
        end

        context "does not have attachment" do
            it "does return false" do
                actual = post.is_attached?

                expect(actual).to be_falsy
            end
        end
    end
    
    describe "#save_hashtags" do
        before(:each) do 
            hashtag_text = double
            @hashtag_texts = [hashtag_text]
            @hashtag = double

            allow(Hashtag).to receive(:get_hashtags_by_text).and_return(@hashtag_texts)
            allow(Hashtag).to receive(:new).and_return(@hashtag)
            allow(@hashtag).to receive(:save_on)
        end

        it "does get hashtags from post text" do
            expect(Hashtag).to receive(:get_hashtags_by_text).with(text_contain_hashtag)

            actual = post_with_id_text_contain_hashtag.save_hashtags

            expect(actual).to eq(@hashtag_texts)
        end

        it "should save hashtags" do
            expect(@hashtag).to receive(:save_on).with(post_with_id)

            post_with_id.save_hashtags
        end
    end

    describe "#set_attachment" do
        context "given mock_attachment" do
            it "does have attachment to equal mock_attachment" do
                mock_attachment = double

                post.set_attachment(mock_attachment)

                expect(post.attachment).to eq(mock_attachment)
            end
        end
    end

    describe ".fetch_by_id" do
        context "given id" do
            before(:each) do
                @id = "1"
                rawData = [post_valid_attribute_with_id]        
                        
                allow(mock_client).to receive(:query).and_return(rawData)
            end

            it "does fetch_query with id" do
                fetch_by_id_query = "select * from posts where id = #{@id}"

                expect(mock_client).to receive(:query).with(fetch_by_id_query)
                
                Post.fetch_by_id(@id)
            end

            it "does get post(id, name) to equal with post_valid_attribute_with_id" do
                post = Post.fetch_by_id(@id)

                expect(post.id).to eq(@id)
                expect(post.text).to eq(post_valid_attribute_with_id["text"])
            end
        end
    end

    describe ".fetch_by_hashtag_text" do
        context "given hashtag text" do
            before(:each) do
                @hashtag_text = "monday"
                rawData = [post_valid_attribute_with_id_text_contain_hashtag]                
    
                allow(mock_client).to receive(:query).and_return(rawData)
            end

            it "does fetch by hashtag text query by hashtag text" do
                fetch_by_hashtag_text_query = "select * from posts left join postRefs on posts.id = postRefs.post_id where postRefs.post_ref_id is null and posts.text like '%##{@hashtag_text}%';"

                expect(mock_client).to receive(:query).with(fetch_by_hashtag_text_query)

                Post.fetch_by_hashtag_text(@hashtag_text)
            end

            it "does get first posts(id and text) to equal post_with_id_text_contain_hashtag" do
                posts = Post.fetch_by_hashtag_text(@hashtag_text)
                
                expect(posts.first.id).to eq(post_with_id_text_contain_hashtag.id)
                expect(posts.first.text).to eq(post_with_id_text_contain_hashtag.text)
            end
            
        end
    end
end
