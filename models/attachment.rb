class Attachment
    attr_reader :filename, :type, :file, :saved_filename

    def initialize(attribute)
        @filename = attribute["filename"]
        @type = attribute["type"]
        @file = attribute["tempfile"]
        @saved_filename = attribute["saved_filename"] 
    end

    def save_by(user)
        return unless is_allowed?

        @saved_filename = "#{get_random_number_by(user)}#{File.extname(@filename)}"
        file_path = "./public/#{@saved_filename}"
        file_read = @file.read
        
        File.open(file_path, 'w') do |f|
            f.write(file_read)
        end
    end

    def get_random_number_by(user)
        "#{Time.new.to_a[0,6].join}#{user.id}"
    end

    def is_allowed?
        return true if ["video/mp4", "image/png", "image/gif", "image/jpeg"].include?(@type) || (@type.include?("text"))

        @saved_filename = "NULL"
        false
    end
end