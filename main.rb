require 'sinatra'
require_relative 'controllers/user_controller'

post '/users/save' do
    UserController.save(params)
end

post '/users/:id/post' do
    UserController.post(params)
end
