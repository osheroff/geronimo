require 'bundler/setup'
require 'sinatra'

require_relative '../repo/repository/file'

get '/' do
  file = params[:file]
  @file_info = Geronimo::Repository::File.get(file)
  erb :index
end
