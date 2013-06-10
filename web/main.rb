require 'bundler/setup'
require 'sinatra'
require 'multi_json'
require 'json'
require 'sinatra/json'

require_relative '../repo/repository/repository_file'

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

get '/' do
  erb :index
end

get '/file_info' do
  file = $current_file
  @file = Geronimo::Repository::RepositoryFile.get(file)
  erb :file_info
end

get '/poll' do
  file = params[:file]
  100.times do
    if file != $current_file && $current_file
      return json({update: true, file: $current_file})
    end
    sleep 0.1
  end
  json({update: false})
end

get '/update_current_file' do
  $current_file = params[:file]
end
