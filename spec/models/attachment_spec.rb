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

    describe "#save_by" do
        context "given mock_user" do
            it "should call file_path and mock_file_read" do
                f_mock = double
                mock_file_read = double
                mock_user = double
                mock_random_number = double
                mock_extension = double
                file_path = "./public/#{mock_random_number}#{mock_extension}"
                attachment = Attachment.new(attachment_attribute)
    
                allow(attachment).to receive(:is_allowed?).and_return(true)
                allow(attachment).to receive(:get_random_number_by).with(mock_user).and_return(mock_random_number)
                allow(File).to receive(:extname).with(attachment_attribute["filename"]).and_return(mock_extension)
                allow(attachment.file).to receive(:read).and_return(mock_file_read)
                expect(File).to receive(:open).with(file_path, 'w').and_yield(f_mock)
                expect(f_mock).to receive(:write).with(mock_file_read)
    
                attachment.save_by(mock_user)
            end
        end
    end

    describe "#get_random_number_by" do
        context "given mock_user" do
            it "should be to equal expected" do
                mock_user = double
                mock_user_id = double
                mock_time_array = Array.new(10, double)
                attachment = Attachment.new(attachment_attribute)
                joined06_mock_time_array = mock_time_array[0,6].join
                expected = "#{joined06_mock_time_array}#{mock_user_id}"
    
                allow(Time).to receive_message_chain(:new, :to_a).and_return(mock_time_array)
                allow(mock_user).to receive(:id).and_return(mock_user_id)
    
                actual = attachment.get_random_number_by(mock_user)
    
                expect(actual).to eq(expected)
            end
        end
    end
    
    describe "#is_allowed?" do
        context "attachment type is video/mp4" do
            it "should be true" do
                attachment_attribute_with_type_video_mp4 = {
                    "filename" => "filename", 
                    "type" => "video/mp4",
                    "tempfile" => file_mock
                }
                attachment_with_type_video_mp4 = Attachment.new(attachment_attribute_with_type_video_mp4)
                
                expected = attachment_with_type_video_mp4.is_allowed?

                expect(expected).to be_truthy 
            end
        end

        context "attachment type is image/png" do
            it "should be true" do
                attachment_attribute_with_type_image_png = {
                    "filename" => "filename", 
                    "type" => "image/png",
                    "tempfile" => file_mock
                }
                attachment_with_type_image_png = Attachment.new(attachment_attribute_with_type_image_png)
                
                expected = attachment_with_type_image_png.is_allowed?

                expect(expected).to be_truthy 
            end
        end

        context "attachment type is image/gif" do
            it "should be true" do
                attachment_attribute_with_type_image_gif = {
                    "filename" => "filename", 
                    "type" => "image/gif",
                    "tempfile" => file_mock
                }
                attachment_with_type_image_gif = Attachment.new(attachment_attribute_with_type_image_gif)
                
                expected = attachment_with_type_image_gif.is_allowed?

                expect(expected).to be_truthy 
            end
        end

        context "attachment type is image/jpeg" do
            it "should be true" do
                attachment_attribute_with_type_image_jpeg = {
                    "filename" => "filename", 
                    "type" => "image/jpeg",
                    "tempfile" => file_mock
                }
                attachment_with_type_image_jpeg = Attachment.new(attachment_attribute_with_type_image_jpeg)
                
                expected = attachment_with_type_image_jpeg.is_allowed?

                expect(expected).to be_truthy 
            end
        end

        context "attachment type is text/plain" do
            it "should be true" do
                attachment_attribute_with_type_text_plain = {
                    "filename" => "filename", 
                    "type" => "text/plain",
                    "tempfile" => file_mock
                }
                attachment_with_type_text_plain = Attachment.new(attachment_attribute_with_type_text_plain)
                
                expected = attachment_with_type_text_plain.is_allowed?

                expect(expected).to be_truthy 
            end
        end
        
        context "attachment type is text/csv" do
            it "should be true" do
                attachment_attribute_with_type_text_csv = {
                    "filename" => "filename", 
                    "type" => "text/csv",
                    "tempfile" => file_mock
                }
                attachment_with_type_text_csv = Attachment.new(attachment_attribute_with_type_text_csv)
                
                expected = attachment_with_type_text_csv.is_allowed?

                expect(expected).to be_truthy 
            end
        end

        context "attachment type is application/x-tar" do
            it "should be false and set attachment(saved_filename) to equal NULL" do
                attachment_attribute_with_type_application_x_tar = {
                    "filename" => "filename", 
                    "type" => "application/x-tar",
                    "tempfile" => file_mock
                }
                attachment_with_type_text_application_x_tar = Attachment.new(attachment_attribute_with_type_application_x_tar)
                
                expected = attachment_with_type_text_application_x_tar.is_allowed?

                expect(expected).to be_falsy
                expect(attachment_with_type_text_application_x_tar.saved_filename).to eq("NULL")
            end
        end
    end
end

