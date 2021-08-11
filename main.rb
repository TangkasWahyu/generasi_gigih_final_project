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
    HashtagController.trending
end