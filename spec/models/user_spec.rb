require_relative '../../models/user'

describe User do
    describe ".initialize" do
        context "given valid attribute" do
            it "should create object that equal with valid_attribute" do
                valid_attribute = {
                    "username" => "mark",
                    "email" => "mark@mail.com",
                    "bio_description" => "20 years old and grow"
                }

                mark = User.new(valid_attribute)

                expect(mark.username).to  eq(valid_attribute["username"])
                expect(mark.email).to  eq(valid_attribute["email"])
                expect(mark.bio_description).to  eq(valid_attribute["bio_description"])
            end
        end
    end

    describe "#save" do
        context "when mark attribute is valid_attribute" do
            it "should call insert_query with mark attribute" do
                mock_client = double
                valid_attribute = {
                    "username" => "mark",
                    "email" => "mark@mail.com",
                    "bio_description" => "20 years old and grow"
                }
                mark = User.new(valid_attribute)
                insert_query = "insert into users (username, email, bio_description) values ('#{mark.username}', '#{mark.email}', '#{mark.bio_description}')"
                
                allow(Mysql2::Client).to receive(:new).and_return(mock_client)
                expect(mock_client).to receive(:query).with(insert_query)

                mark.save
            end
        end
    end
    
    describe ".get_by_id" do
        context "given id is 1" do
            it "should call get_by_id_query with id equal 1 and get user with id 1" do
                mock_client = double
                id = "1"
                get_by_id_query = "select * from users where id = #{id}"
                valid_attribute = {
                    "id" => "1",
                    "username" => "mark",
                    "email" => "mark@mail.com",
                    "bio_description" => "20 years old and grow"
                }
                rawData = [valid_attribute]                

                allow(Mysql2::Client).to receive(:new).and_return(mock_client)
                expect(mock_client).to receive(:query).with(get_by_id_query).and_return(rawData)
                expect(get_by_id_query).to include(id) 

                user = User.get_by_id(id)

                expect(user.id).to eq(id) 
            end
        end
    end
    
end
