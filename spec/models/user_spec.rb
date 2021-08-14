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

    describe "#send" do
        it "call user" do
            mock_text = double

            expect(mock_text).to receive(:send_by).with(user)

            user.send(mock_text)
        end
    end
end
