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
            let(:mock_user) { double } 
            let(:mock_user_id) { double } 
            let(:mock_extension) { double } 
            let(:mock_file_read) { double } 
            let(:f_mock) { double } 
            let(:attachment_attribute_without_type) {{
                "filename" => "filename",
                "tempfile" => file_mock
            }}
            let(:mock_time_array) { Array.new(10, double) } 
            let(:joined06_mock_time_array) { mock_time_array[0,6].join } 
            let(:file_path) { "./public/#{joined06_mock_time_array}#{mock_user_id}#{mock_extension}" } 

            before(:each) do
                allow(Time).to receive_message_chain(:new, :to_a).and_return(mock_time_array)
                allow(mock_user).to receive_message_chain(:id).and_return(mock_user_id)
                allow(File).to receive(:extname).and_return(mock_extension)
                allow(file_mock).to receive(:read).and_return(mock_file_read)
            end

            context "attachment type is video/mp4" do
                let(:attachment_attribute_with_type_video_mp4) {{
                    **attachment_attribute_without_type,
                    "type" => "video/mp4"
                }}
                let(:attachment_with_type_video_mp4) { Attachment.new attachment_attribute_with_type_video_mp4 }
    
                it "does save file in expected file path" do
                    expect(File).to receive(:open).with(file_path, 'w').and_yield(f_mock)
                    expect(f_mock).to receive(:write).with(mock_file_read)

                    attachment_with_type_video_mp4.attached_by(mock_user) 
                end
            end
    
            context "attachment type is image/png" do
                let(:attachment_attribute_with_type_image_png) {{
                    **attachment_attribute_without_type,
                    "type" => "image/png"
                }}
                let(:attachment_with_type_image_png) { Attachment.new attachment_attribute_with_type_image_png }
    
                it "does save file in expected file path" do
                    expect(File).to receive(:open).with(file_path, 'w').and_yield(f_mock)
                    expect(f_mock).to receive(:write).with(mock_file_read)

                    attachment_with_type_image_png.attached_by(mock_user) 
                end
            end
    
            context "attachment type is image/gif" do
                let(:attachment_attribute_with_type_image_gif) {{
                    **attachment_attribute_without_type,
                    "type" => "image/gif"
                }}
                let(:attachment_with_type_image_gif) { Attachment.new attachment_attribute_with_type_image_gif }
    
                it "does save file in expected file path" do
                    expect(File).to receive(:open).with(file_path, 'w').and_yield(f_mock)
                    expect(f_mock).to receive(:write).with(mock_file_read)

                    attachment_with_type_image_gif.attached_by(mock_user) 
                end
            end
    
            context "attachment type is image/jpeg" do
                let(:attachment_attribute_with_type_image_jpeg) {{
                    **attachment_attribute_without_type,
                    "type" => "image/jpeg"
                }}
                let(:attachment_with_type_image_jpeg) { Attachment.new attachment_attribute_with_type_image_jpeg }
    
                it "does save file in expected file path" do
                    expect(File).to receive(:open).with(file_path, 'w').and_yield(f_mock)
                    expect(f_mock).to receive(:write).with(mock_file_read)

                    attachment_with_type_image_jpeg.attached_by(mock_user) 
                end
            end
    
            context "attachment type is text/plain" do
                let(:attachment_attribute_with_type_text_plain) {{
                    **attachment_attribute_without_type,
                    "type" => "text/plain"
                }}
                let(:attachment_with_type_text_plain) { Attachment.new attachment_attribute_with_type_text_plain }
    
                it "does save file in expected file path" do
                    
                    expect(File).to receive(:open).with(file_path, 'w').and_yield(f_mock)
                    expect(f_mock).to receive(:write).with(mock_file_read)

                    attachment_with_type_text_plain.attached_by(mock_user) 
                end
            end
            
            context "attachment type is text/csv" do
                let(:attachment_attribute_with_type_text_csv) {{
                    **attachment_attribute_without_type,
                    "type" => "text/csv"
                }}
                let(:attachment_with_type_text_csv) { Attachment.new attachment_attribute_with_type_text_csv }
    
                it "does save file in expected file path" do
                    expect(File).to receive(:open).with(file_path, 'w').and_yield(f_mock)
                    expect(f_mock).to receive(:write).with(mock_file_read)

                    attachment_with_type_text_csv.attached_by(mock_user) 
                end
            end
    
            context "attachment type is application/x-tar" do
                let(:attachment_attribute_with_type_application_x_tar) {{
                    **attachment_attribute_without_type,
                    "type" => "application/x-tar"
                }}
                let(:attachment_with_type_text_application_x_tar) { Attachment.new attachment_attribute_with_type_application_x_tar }
    
                it "does not save file in expected file path" do
                    expect(File).not_to receive(:open).with(file_path, 'w').and_yield(f_mock)
                    expect(f_mock).not_to receive(:write).with(mock_file_read)

                    attachment_with_type_text_application_x_tar.attached_by(mock_user) 
                end
            end
        end
    end
end
