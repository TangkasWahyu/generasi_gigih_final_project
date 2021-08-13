class Attachment
    attr_reader :filename, :file
    
    def initialize(attribute)
        @filename = attribute["filename"]
        @file = attribute["tempfile"]
    end
end