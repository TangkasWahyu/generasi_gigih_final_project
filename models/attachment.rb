class Attachment
    attr_reader :filename, :file
    
    def initialize(attribute)
        @filename = attribute["filename"]
        @file = attribute["tempfile"]
    end

    def save
    end
end