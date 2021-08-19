class Attachment
    attr_reader :filename, :type, :file, :saved_filename, :user

    def initialize(attribute)
        @filename = attribute["filename"]
        @type = attribute["type"]
        @file = attribute["tempfile"]
        @saved_filename = attribute["saved_filename"]
        @user = attribute["user"]
    end

    def attached_by(user)
        return unless is_allowed?

        @user = user
        @saved_filename = get_filename

        save
    end

    def is_allowed?
        return true if ["video/mp4", "image/png", "image/gif", "image/jpeg"].include?(@type) || (@type.include?("text"))

        @saved_filename = "NULL"
        false
    end

    def get_filename
        "#{get_random_number}#{File.extname(@filename)}"
    end

    def save
        file_path = "./public/#{@saved_filename}"
        file_read = @file.read
        
        File.open(file_path, 'w') do |f|
            f.write(file_read)
        end
    end

    def get_random_number
        "#{Time.new.to_a[0,6].join}#{@user.id}"
    end

    private :get_random_number
end