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

get '/posts/hashtags/:hashtag_id' do
    PostController.get_by_hashtag(params)
end