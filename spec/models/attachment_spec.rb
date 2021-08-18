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
        context "type is allowed have user and saved file name" do
            before(:each) do
                @mock_saved_filename = double
                attachment_attribute = {
                    "filename" => "filename",
                    "type" => "video/mp4",
                    "tempfile" => file_mock,
                    "saved_filename" => @mock_saved_filename,
                    "user" => double
                }
                @attachment = Attachment.new(attachment_attribute)
    
                allow(@attachment).to receive(:is_allowed?).and_return(true)
            end

            context "given mock user" do
                before(:each) do
                    allow(@attachment).to receive(:set_filename)
                    allow(@attachment.file).to receive(:read).and_return(@mock_file_read)
                end

                it "does save file in file_path" do
                    f_mock = double
                    mock_user = double
                    file_path = "./public/#{@mock_saved_filename}"
                    
                    expect(File).to receive(:open).with(file_path, 'w').and_yield(f_mock)
                    expect(f_mock).to receive(:write).with(@mock_file_read)
        
                    @attachment.attached_by(mock_user)
                end
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

    describe "#get_random_number" do
        context "have mock_user" do
            before(:each) do
                mock_user = double
                attachment_attribute = {
                    "filename" => "filename",
                    "type" => "video/mp4",
                    "tempfile" => file_mock,
                    "user" => mock_user
                }
                @attachment = Attachment.new(attachment_attribute)
                mock_user_id = double
                mock_time_array = Array.new(10, double)
                @joined06_mock_time_array = mock_time_array[0,6].join

                allow(Time).to receive_message_chain(:new, :to_a).and_return(mock_time_array)
                allow(mock_user).to receive_message_chain(:id).and_return(@mock_user_id)
            end

            it "does return random number" do
                expected = "#{@joined06_mock_time_array}#{@mock_user_id}"
    
                actual = @attachment.get_random_number
    
                expect(actual).to eq(expected)
            end
        end
    end
end
