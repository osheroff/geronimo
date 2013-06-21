require "geronimo_client/version"
require "uuid"
require "json"
require "faraday"

module GeronimoClient
  class Client
    def initialize()
      @url = 'http://localhost:4567'
      @connection = Faraday.new(:url => @url)
    end

    def uuid
      @uuid ||= UUID.generate
    end

    def set_current_file(file)
      @current_file = file
      ping!
    end

    def post(url, obj)
      @connection.post do |req|
        req.url url
        req.headers['Content-Type'] = 'application/json'
        req.body = obj.merge("session" => uuid).to_json
      end
    rescue
      nil
    end

    def ping!
      post("/editor/ping", :file => @current_file)
    end
  end
end
