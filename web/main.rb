require 'bundler/setup'
require 'sinatra'

require_relative '../repo/repository/repository_file'

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

get '/file_info' do
  file = $current_file
  @file = Geronimo::Repository::RepositoryFile.get(file)
  erb :file_info
end

get '/poll' do
  file = $current_file
  10.times do
    if file != $current_file
      {update: true}.to_json
    end
    sleep 1
  end
  {update: false}.to_json
end

get '/update_current_file' do
  $current_file = params[:file]
end
