require 'sinatra/base'
require 'sinatra/reloader'

class Application < Sinatra::Base
  # This allows the app code to refresh
  # without having to restart the server.
  configure :development do
    register Sinatra::Reloader
  end

  get '/hello' do
    name = params[:name]

    # return "Hello #{name}"
    return erb(:index)
  end

  post '/submit' do
    name = params[:name]
    message = params[:message]

    return "Thanks #{name}, you sent this message: \"#{message}\""
  end

  get '/names' do
    #names = params[:names]
    #return names
    return 'Julia, Mary, Karim'
  end

  post '/sort-names' do
    # body parameter is a comma seperate string
    names = params[:names]
    sorted_names = names.split(',').sort.join(',')
    return sorted_names
  end
end