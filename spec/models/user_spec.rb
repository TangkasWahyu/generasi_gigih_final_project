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
    
end
