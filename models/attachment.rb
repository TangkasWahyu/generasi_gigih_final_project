class Attachment
    attr_reader :filename, :file

    def initialize(attribute)
        @filename = attribute["filename"]
        @type = attribute["type"]
        @file = attribute["tempfile"]
    end

    def save
        return unless is_allowed?

        save_location = "./public/#{@filename}"
        file_read = @file.read
        
        File.open(save_location, 'wb') do |f|
            f.write(file_read)
        end
    end

    def is_allowed?
        return true if ["video/mp4", "image/png", "image/gif", "image/jpeg"].include?(@type) || (@type.include?("text"))

        false
    end
end