require 'sinatra'
require_relative 'controllers/user_controller'
require_relative 'controllers/hashtag_controller'

post '/users/save' do
    UserController.save(params)
end

post '/users/:id/post' do
    UserController.post(params)
end

get '/hashtags/trending' do
    trending_hashtags = HashtagController.trending
    trending_hashtags.map.with_index(1) { |trending_hashtag, index| "#{index} #{trending_hashtag.to_s}" }.join(" | ")
end

post '/users/:user_id/posts/:post_id/comment' do
    UserController.comment(params)
end

get '/hashtags/:hashtag_text/posts' do
    posts_get_by_hashtag_text = HashtagController.get_by_hashtag_text(params)
    posts_get_by_hashtag_text.map.with_index(1) { |post, index| "#{index} #{post.text}" }.join(" | ")
end