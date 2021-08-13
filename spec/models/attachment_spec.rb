require_relative '../test_helper'
require_relative '../../models/attachment'

describe Attachment do
    describe ".initialize" do
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
end

