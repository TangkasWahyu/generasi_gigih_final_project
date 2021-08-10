class Hashtag
    attr_reader :text
    
    def initialize(text)
        @text = text
    end

    def self.save_hashtags(hashtags)
        hashtags.each do |hashtag|
            hashtag = Hashtag.new(hashtag)
            hashtag.save
        end
    end

    def save
    end
end