class Post
    attr_reader :text

    def initialize(attribute)
        @text = attribute["text"]
    end

    def save
    end
end