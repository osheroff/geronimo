require_relative 'helper'
require_relative '../web/main'

describe "geronimo" do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  describe "/" do
    it "doesn't crash" do
      get '/', :file => '/Users/ben/src/zendesk/app/controllers/photos_controller.rb'
      last_response.should be_ok
    end
  end
end

