require_relative '../test_helper'
require_relative '../../models/attachment'

describe Attachment do
    let(:file_mock) { double }
    let(:attachment_attribute) {{
        "filename" => "filename",
        "type" => "video/mp4",
        "tempfile" => file_mock
    }}
    
    describe "#initialize" do
        context "given attachment_attribute" do
            it "should expected(filename, file) equal to attachment_attribute(filename, tempfile)" do
                expected = Attachment.new(attachment_attribute)
        
                expect(expected.filename).to eq(attachment_attribute["filename"])
                expect(expected.type).to eq(attachment_attribute["type"])
                expect(expected.file).to eq(attachment_attribute["tempfile"])
            end
        end
    end

    describe "#attached_by" do
        context "given mock user" do
            let(:mock_file_name) { double }
            let(:attachment) { Attachment.new attachment_attribute }

            before(:each) do
                allow(attachment).to receive(:get_filename).and_return(mock_file_name)
                allow(attachment).to receive(:save)
            end

            context "is allowed" do
                before(:each) do
                    allow(attachment).to receive(:is_allowed?).and_return(true)
                end
                
                it "does have user" do
                    mock_user = double

                    attachment.attached_by(mock_user)

                    expect(attachment.user).to eq(mock_user)
                end

                it "does have saved file name" do
                    mock_user = double

                    attachment.attached_by(mock_user)

                    expect(attachment.saved_filename).to eq(mock_file_name)
                end
            end
        end
    end

    describe "save" do
        context "have user and saved file name" do
            let(:mock_saved_filename) { double } 
            let(:mock_file_read) { double } 
            let(:attachment_attribute_with_user_and_file_name) {{
                **attachment_attribute,
                "saved_filename" => mock_saved_filename,
                "user" => double
            }} 
            let(:attachment_have_user_and_file_name) { Attachment.new attachment_attribute_with_user_and_file_name } 

            before(:each) do
                allow(file_mock).to receive(:read).and_return(mock_file_read)
            end

            it "does save file in file_path" do
                f_mock = double
                file_path = "./public/#{mock_saved_filename}"
                
                expect(File).to receive(:open).with(file_path, 'w').and_yield(f_mock)
                expect(f_mock).to receive(:write).with(mock_file_read)
    
                attachment_have_user_and_file_name.save
            end
        end
    end

    describe "#is_allowed?" do
        let(:attachment_attribute_without_type) {{
            "filename" => "filename",
            "tempfile" => file_mock
        }}
        
        context "attachment type is video/mp4" do
            let(:attachment_attribute_with_type_video_mp4) {{
                **attachment_attribute_without_type,
                "type" => "video/mp4"
            }}
            let(:attachment_with_type_video_mp4) { Attachment.new attachment_attribute_with_type_video_mp4 }

            it "should be true" do
                expected = attachment_with_type_video_mp4.is_allowed?

                expect(expected).to be_truthy 
            end
        end

        context "attachment type is image/png" do
            let(:attachment_attribute_with_type_image_png) {{
                **attachment_attribute_without_type,
                "type" => "image/png"
            }}
            let(:attachment_with_type_image_png) { Attachment.new attachment_attribute_with_type_image_png }

            it "should be true" do
                expected = attachment_with_type_image_png.is_allowed?

                expect(expected).to be_truthy 
            end
        end

        context "attachment type is image/gif" do
            let(:attachment_attribute_with_type_image_gif) {{
                **attachment_attribute_without_type,
                "type" => "image/gif"
            }}
            let(:attachment_with_type_image_gif) { Attachment.new attachment_attribute_with_type_image_gif }

            it "should be true" do
                expected = attachment_with_type_image_gif.is_allowed?

                expect(expected).to be_truthy 
            end
        end

        context "attachment type is image/jpeg" do
            let(:attachment_attribute_with_type_image_jpeg) {{
                **attachment_attribute_without_type,
                "type" => "image/jpeg"
            }}
            let(:attachment_with_type_image_jpeg) { Attachment.new attachment_attribute_with_type_image_jpeg }

            it "should be true" do
                expected = attachment_with_type_image_jpeg.is_allowed?

                expect(expected).to be_truthy 
            end
        end

        context "attachment type is text/plain" do
            let(:attachment_attribute_with_type_text_plain) {{
                **attachment_attribute_without_type,
                "type" => "text/plain"
            }}
            let(:attachment_with_type_text_plain) { Attachment.new attachment_attribute_with_type_text_plain }

            it "should be true" do
                expected = attachment_with_type_text_plain.is_allowed?

                expect(expected).to be_truthy 
            end
        end
        
        context "attachment type is text/csv" do
            let(:attachment_attribute_with_type_text_csv) {{
                **attachment_attribute_without_type,
                "type" => "text/csv"
            }}
            let(:attachment_with_type_text_csv) { Attachment.new attachment_attribute_with_type_text_csv }

            it "should be true" do
                expected = attachment_with_type_text_csv.is_allowed?

                expect(expected).to be_truthy 
            end
        end

        context "attachment type is application/x-tar" do
            let(:attachment_attribute_with_type_application_x_tar) {{
                **attachment_attribute_without_type,
                "type" => "application/x-tar"
            }}
            let(:attachment_with_type_text_application_x_tar) { Attachment.new attachment_attribute_with_type_application_x_tar }

            it "should be false and set attachment(saved_filename) to equal NULL" do
                expected = attachment_with_type_text_application_x_tar.is_allowed?

                expect(expected).to be_falsy
                expect(attachment_with_type_text_application_x_tar.saved_filename).to eq("NULL")
            end
        end
    end

    describe "#get_filename" do
        context "have user" do
            let(:attachment_attribute_have_user) {{
                **attachment_attribute,
                "user" => double
            }} 
            let(:mock_random_number) { double } 
            let(:mock_extension) { double } 
            let(:attachment_have_user) { Attachment.new attachment_attribute_have_user } 

            before(:each) do
                allow(attachment_have_user).to receive(:get_random_number).and_return(mock_random_number)
                allow(File).to receive(:extname).and_return(mock_extension)
            end

            it "does return saved filename to equal expected" do
                expected = "#{mock_random_number}#{mock_extension}"

                actual = attachment_have_user.get_filename

                expect(actual).to eq(expected)
            end
        end
    end

    describe "#get_random_number" do
        context "have mock_user" do
            let(:mock_user) { double } 
            let(:mock_user_id) { double } 
            let(:attachment_attribute_with_user) {{
                **attachment_attribute,
                "user" => mock_user
            }}
            let(:attachment_have_user) { Attachment.new attachment_attribute_with_user } 
            let(:mock_time_array) { Array.new(10, double) } 
            let(:joined06_mock_time_array) { mock_time_array[0,6].join } 

            before(:each) do
                allow(Time).to receive_message_chain(:new, :to_a).and_return(mock_time_array)
                allow(mock_user).to receive_message_chain(:id).and_return(mock_user_id)
            end

            it "does return random number" do
                expected = "#{joined06_mock_time_array}#{mock_user_id}"
    
                actual = attachment_have_user.get_random_number
    
                expect(actual).to eq(expected)
            end
        end
    end
end
