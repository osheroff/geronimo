require "geronimo_client/version"
require "uuid"
require "json"
require "faraday"

module GeronimoClient
  class Client
    def initialize()
      @url = 'http://localhost:4567'
      @connection = Faraday.new(:url => @url)
      @status_filename = "/tmp/geronimo.#{uuid}"
      @command_filename = "/tmp/geronimo.#{uuid}.commands"
    end

    def uuid
      @uuid ||= UUID.generate
    end

    def set_current_file(file)
      if @current_file != file
        @current_file = file
        write_status
      else
        ping!
      end
    end

    def write_status
      File.open(@status_filename, "w+") { |f| f.write(status.to_json) }
    end

    def status
      {:uuid => uuid, :file => @current_file, :pid => $$}
    end

    def ping!
      File.utime(Time.now, Time.now, @status_filename)
    end

    def command_queue
      @command_queue ||= []
    end

    def read_commands
      if File.exist?(@command_filename)
        command_queue.concat File.readlines(@command_filename).map { |l| JSON.parse(l) }
        File.unlink(@command_filename)
      end
    end

    def get_command
      read_commands
      command_queue.shift
    end
  end
end
