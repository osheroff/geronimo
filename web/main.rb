require 'bundler/setup'
require 'sinatra'
require 'multi_json'
require 'json'
require 'sinatra/json'
require 'digest/md5'


require_relative '../repo/repository/repository_file'
require_relative 'server/editor_state'

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end

  def gravatar_url(author, size=50)
    "http://www.gravatar.com/avatar/" + Digest::MD5.hexdigest(author.email.strip.downcase) + "?s=#{size}"
  end
end

Thread.abort_on_exception = true
$state = Geronimo::Server::EditorState.new

Thread.new do
  while true
    $state.refresh!
    sleep(0.2)
  end
end

get '/' do
  erb :index
end

get '/file_info' do
  @files = $state.files
  erb :file_info
end

get '/poll' do
  hash = params[:hash]
  100.times do
    md5 = Digest::MD5.hexdigest($state.hash.to_s)

    if md5 != hash.to_s
      return json({update: true, hash: md5})
    end
    sleep 0.1
  end
  json({update: false})
end
