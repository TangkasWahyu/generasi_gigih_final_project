class Attachment
    attr_reader :filename, :file

    def initialize(attribute)
        @filename = attribute["filename"]
        @file = attribute["tempfile"]
    end

    def save
        save_location = "./public/#{@filename}"
        file_read = @file.read
        
        File.open(save_location, 'wb') do |f|
            f.write(file_read)
        end
    end
end