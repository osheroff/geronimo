require 'thread'
require 'rubygems'
require 'bundler'

ENV["BUNDLE_GEMFILE"] = File.expand_path(File.dirname(__FILE__)) + "/Gemfile"
Bundler.setup

require 'geronimo_client'
Thread.abort_on_exception = true
module Geronimo
  class Vim
    def initialize()
      @mutex = Mutex.new
      @current_file = nil
    end

    def client
      @client ||= GeronimoClient::Client.new
    end

    def set_current_file
      client.set_current_file(@current_file)
    end

    def cursor_moved
      @current_file = VIM::evaluate("fnamemodify(bufname('%'), ':p')")

      run_commands
      Thread.new do
        if @mutex.try_lock
          begin
            set_current_file
            sleep 0.2
          ensure
            @mutex.unlock
          end
        end
      end
    end

    def run_commands
      while (cmd = client.get_command)
        parse_command(cmd)
      end
    end

    def parse_command(cmd)
      case cmd['command']
      when 'open-file'
        VIM::command("sp #{cmd['filename']}")
      end
    end
  end
end
