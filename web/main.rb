require 'bundler/setup'
require 'sinatra'

require_relative '../repo/repository/repository_file'

get '/' do
  file = params[:file]
  @file = Geronimo::Repository::RepositoryFile.get(file)
  erb :index
end
