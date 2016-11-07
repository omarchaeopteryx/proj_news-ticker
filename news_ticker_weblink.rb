require 'sinatra'

get '/' do
  name = params[:name]
  "Hello, #{name}!"
end
