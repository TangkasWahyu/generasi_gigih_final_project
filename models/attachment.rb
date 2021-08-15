class Attachment
    attr_reader :filename, :type, :file

    def initialize(attribute)
        @filename = attribute["filename"]
        @type = attribute["type"]
        @file = attribute["tempfile"]
    end

    def save_at(path)
        return unless is_allowed?

        file_read = @file.read
        
        File.open(path, 'wb') do |f|
            f.write(file_read)
        end
    end

    def is_allowed?
        return true if ["video/mp4", "image/png", "image/gif", "image/jpeg"].include?(@type) || (@type.include?("text"))

        false
    end
end