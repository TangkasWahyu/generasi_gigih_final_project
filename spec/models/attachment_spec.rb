require_relative '../test_helper'
require_relative '../../models/attachment'

describe Attachment do
    describe "#initialize" do
        context "given attachment_attribute" do
            it "should expected(filename, file) equal to attachment_attribute(filename, tempfile)" do
                attachment_attribute = {
                    "filename" => "filename", 
                    "type" => "filetype", 
                    "name" => "name", 
                    "tempfile" => "tempfile"
                }
                        
                expected = Attachment.new(attachment_attribute)
        
                expect(expected.filename).to eq(attachment_attribute["filename"])
                expect(expected.file).to eq(attachment_attribute["tempfile"])
            end
        end
    end

    describe "#save" do
        it "should call save_location" do
            f_mock = double
            file_mock = double
            file_read = double
            attachment_attribute = {
                "filename" => "filename", 
                "tempfile" => file_mock
            }
            attachment = Attachment.new(attachment_attribute)
            save_location = "./public/#{attachment.filename}"

            expect(File).to receive(:open).with(save_location, 'wb').and_yield(f_mock)
            allow(attachment.file).to receive(:read).and_return(file_read)
            allow(f_mock).to receive(:write).with(file_read)

            attachment.save
        end
    end
end

