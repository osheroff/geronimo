module Geronimo
  module Server
    class EditorFile
      attr_reader :filename, :pid, :mtime
      def initialize(hash)
        @filename = hash['file']
        @pid = hash['pid']
        @uuid = hash['uuid']
        @mtime = hash['last_activity']
      end

      def hash
        [@filename, @mtime, @pid].hash
      end

      def active?
        return false unless File.exists?(@filename)
        begin
          Process.kill(0, @pid)
        rescue Errno::ESRCH
          return false
        end
        true
      end

      def repository_file
        @repo_file ||= Geronimo::Repository::RepositoryFile.get(@filename)
      end

      def type
        case File.extname(@filename)
        when ".rb", ".erb"
          :ruby
        when ".js"
          :javascript
        when ".css"
          :css
        when ""
          case File.basename(@filename)
            when "Gemfile", "Gemfile.lock", "Rakefile"
              :ruby
          end
        end
      end
    end
  end
end
