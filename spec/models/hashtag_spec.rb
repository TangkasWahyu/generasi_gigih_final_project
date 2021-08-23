require_relative '../test_helper'
require_relative '../../models/hashtag'
require_relative '../../models/post'

describe Hashtag do
  describe '#initialize' do
    context 'given monday' do
      let(:hashtag) { Hashtag.new('monday') }

      it 'does create object(text) to equal monday' do
        expect(hashtag.text).to eq('monday')
      end
    end
  end

  describe '#save_on' do
    context 'given post' do
      let(:post_text) { 'Hello world? #monday' }
      let(:post_id) { '1' }
      let(:post_attribute) do
        {
          'text' => post_text,
          'id' => post_id
        }
      end
      let(:post) { Post.new post_attribute }

      let(:text) { 'monday' }
      let(:hashtag) { Hashtag.new text }

      let(:mock_client) { double }
      let(:mock_last_id) { double }
      let(:insert_hashtag_query) { "insert into hashtags (text, post_id) values ('#{text}', #{post_id})" }

      before(:each) do
        allow(Mysql2::Client).to receive(:new).and_return(mock_client)
        allow(mock_client).to receive(:last_id).and_return(mock_last_id)
      end

      it 'does save hashtag' do
        expect(mock_client).to receive(:query).with(insert_hashtag_query)

        hashtag.save_on(post)
      end
    end
  end

  describe '.contained?' do
    context 'given text contain #monday' do
      let(:text) { 'Hello world #monday' }

      it 'does return true' do
        actual = Hashtag.contained?(text)

        expect(actual).to be_truthy
      end
    end

    context 'given text contain no hashtag' do
      let(:text) { 'Hello world' }

      it 'does return false' do
        actual = Hashtag.contained?(text)

        expect(actual).to be_falsy
      end
    end
  end

  describe '.get_hashtags_by_text' do
    context 'text contain #monday' do
      let(:text) { 'Hello world #monday' }
      let(:expected) { ['#monday'] }

      it 'does return #monday' do
        actual = Hashtag.get_hashtags_by_text(text)

        expect(actual).to eq(expected)
      end
    end

    context 'text contain no hashtag' do
      let(:text) { 'Hello world' }
      let(:expected) { [] }

      it 'does return empty array' do
        actual = Hashtag.get_hashtags_by_text(text)

        expect(actual).to eq(expected)
      end
    end

    context 'text contain #Monday' do
      let(:text) { 'Hello world #Monday' }
      let(:expected) { ['#monday'] }

      it 'does return array that contain #monday only' do
        actual = Hashtag.get_hashtags_by_text(text)

        expect(actual).to eq(expected)
      end
    end

    context 'text contain #Monday and #tuesday' do
      let(:text) { 'Hello world #monday #tuesday' }
      let(:expected) { ['#monday', '#tuesday'] }

      it 'does return array that contain #monday and #tuesday only' do
        actual = Hashtag.get_hashtags_by_text(text)

        expect(actual).to eq(expected)
      end
    end

    context 'text contain #monday and #monday' do
      let(:text) { 'Hello world #monday #monday' }
      let(:expected) { expected = ['#monday'] }

      it 'does return array that contain #monday only' do
        actual = Hashtag.get_hashtags_by_text(text)

        expect(actual).to eq(expected)
      end
    end
  end

  describe '.fetch_trending' do
    let(:mock_client) { double }
    let(:monday_hashtag_attribute) do
      {
        'id' => double,
        'text' => '#monday'
      }
    end
    let(:tuesday_hashtag_attribute) do
      {
        'id' => double,
        'text' => '#tuesday'
      }
    end
    let(:trending_hashtags) { [monday_hashtag_attribute, tuesday_hashtag_attribute] }

    before(:each) do
      allow(Mysql2::Client).to receive(:new).and_return(mock_client)
      allow(mock_client).to receive(:query).and_return(trending_hashtags)
    end

    it 'does get trending hashtags' do
      hashtags = Hashtag.fetch_trending

      expect(hashtags[0].text).to eq(monday_hashtag_attribute['text'])
      expect(hashtags[1].text).to eq(tuesday_hashtag_attribute['text'])
    end
  end
end
