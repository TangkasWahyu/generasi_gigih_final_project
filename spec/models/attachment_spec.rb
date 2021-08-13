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

    describe "#save" do
        it "should call save_location" do
            f_mock = double
            file_read = double
            attachment = Attachment.new(attachment_attribute)
            save_location = "./public/#{attachment.filename}"

            allow(attachment).to receive(:is_allowed?).and_return(true)
            expect(File).to receive(:open).with(save_location, 'wb').and_yield(f_mock)
            allow(attachment.file).to receive(:read).and_return(file_read)
            allow(f_mock).to receive(:write).with(file_read)

            attachment.save
        end
    end

    describe "#is_valid?" do
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
            it "should be false" do
                attachment_attribute_with_type_application_x_tar = {
                    "filename" => "filename", 
                    "type" => "application/x-tar",
                    "tempfile" => file_mock
                }
                attachment_with_type_text_application_x_tar = Attachment.new(attachment_attribute_with_type_application_x_tar)
                
                expected = attachment_with_type_text_application_x_tar.is_allowed?

                expect(expected).to be_falsy
            end
        end
    end
end

