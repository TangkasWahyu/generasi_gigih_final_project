require_relative '../test_helper'
require_relative '../../models/user'
require_relative '../../models/post'

describe User do
    let(:user_valid_attribute) {{
        "id" => "1",
        "username" => "mark",
        "email" => "mark@mail.com",
        "bio_description" => "20 years old and grow"
    }}
    let(:user) { User.new user_valid_attribute }
    let(:mock_client) {double}

    before(:each) do
        allow(Mysql2::Client).to receive(:new).and_return(mock_client)
    end

    describe ".initialize" do
        context "given valid attribute" do
            it "should create object that equal with user_valid_attribute" do
                expect(user.username).to  eq(user_valid_attribute["username"])
                expect(user.email).to  eq(user_valid_attribute["email"])
                expect(user.bio_description).to  eq(user_valid_attribute["bio_description"])
            end
        end
    end

    describe "#save" do
        context "when user attribute is user_valid_attribute" do
            it "should call insert_query with user attribute" do
                insert_query = "insert into users (username, email, bio_description) values ('#{user.username}', '#{user.email}', '#{user.bio_description}')"
                
                expect(mock_client).to receive(:query).with(insert_query)

                user.save
            end
        end
    end
    
    describe ".get_by_id" do
        context "given id is 1" do
            it "should call get_by_id_query with id equal 1 and get user with id 1" do
                id = "1"
                get_by_id_query = "select * from users where id = #{id}"
                rawData = [user_valid_attribute]                

                expect(mock_client).to receive(:query).with(get_by_id_query).and_return(rawData)
                expect(get_by_id_query).to include(id) 

                user = User.get_by_id(id)

                expect(user.id).to eq(id) 
            end
        end
    end
    
    describe "#post" do
        context "when user post with hello_world_post" do
            it "should call insert_post_query and return 1" do
                hello_world_attribute = {
                    "text" => "Hello world"
                }
                hello_world_post = Post.new(hello_world_attribute)
                insert_post_query = "insert into posts (user_id, text) values ('#{user_valid_attribute["id"]}','#{hello_world_attribute["text"]}')"

                expect(mock_client).to receive(:query).with(insert_post_query)
                allow(mock_client).to receive(:last_id).and_return(1)

                actual = user.post(hello_world_post)

                expect(actual).to eq(1)
            end
        end
    end
    
    describe "#add_post" do
        context "given mock_post" do
            it "should return user.posts end_with mock_post" do
                mock_post = double

                user.add_post(mock_post)

                expect(user.posts).to end_with(mock_post) 
            end
        end
    end
end
