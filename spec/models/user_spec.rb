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
end
