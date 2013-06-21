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

  def gravatar_url(author, size=50)
    "http://www.gravatar.com/avatar/" + Digest::MD5.hexdigest(author.email.strip.downcase) + "?s=#{size}"
  end
end

get '/' do
  erb :index
end

get '/file_info' do
  @file = $repo_file
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

post "/editor/ping" do
  request.body.rewind  # in case someone already read it
  data = JSON.parse request.body.read
  fname = data['file']
  repo_file = Geronimo::Repository::RepositoryFile.get(fname)
  if repo_file
    $repo_file = repo_file
    $current_file = fname
  end
  json({status: "ok"})
end
