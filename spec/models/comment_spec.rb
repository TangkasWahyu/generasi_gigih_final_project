require_relative '../test_helper'
require_relative '../../models/user'
require_relative '../../models/post'
require_relative '../../models/comment'

describe Comment do
  describe '#send_by' do
    context 'given user have post' do
      let(:post_text) { 'Hello world?' }
      let(:post_id) { '1' }
      let(:post_attribute) do
        {
          'text' => post_text,
          'id' => post_id
        }
      end
      let(:post) { Post.new post_attribute }

      let(:user_id) { '1' }
      let(:user_with_post_attribute) do
        {
          'username' => 'Dipsi',
          'email' => 'dipsi@teletabis.co.id',
          'bio_description' => 'am I Dipsi?',
          'id' => user_id,
          'post' => post
        }
      end
      let(:user_have_post) { User.new user_with_post_attribute }

      let(:comment_text) { 'Why Hello world?' }
      let(:comment_attribute) do
        {
          'text' => comment_text
        }
      end
      let(:comment) { Comment.new comment_attribute }

      let(:mock_client) { double }
      let(:last_id) { double }
      let(:insert_post_query) { "insert into posts (user_id, text) values ('#{user_id}','#{comment_text}')" }
      let(:insert_post_ref_query) do
        "insert into postRefs (post_id, post_ref_id) values (#{last_id}, #{post_id})"
      end

      before(:each) do
        allow(Mysql2::Client).to receive(:new).and_return(mock_client)
        allow(mock_client).to receive(:last_id).and_return(last_id)
        allow(mock_client).to receive(:query)
      end

      it 'does save comment' do
        expect(mock_client).to receive(:query).with(insert_post_query)
        expect(mock_client).to receive(:query).with(insert_post_ref_query)

        comment.send_by(user_have_post)
      end
    end
  end
end
