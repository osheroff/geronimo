module Geronimo
  module Server
    class EditorFile
      attr_reader :filename, :pid, :last_activity, :uuid
      def initialize(hash)
        @filename = hash['file']
        @pid = hash['pid']
        @uuid = hash['uuid']
        @last_activity = hash['last_activity']
      end

      def hash
        [@filename, @last_activity, @pid].hash
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

      def syntax_ok?
        case type
          when :ruby
            return :none if File.extname(@filename) == ".erb"
            output = `ruby -c "#{@filename}" 2>&1`
            return true if $?.success?
            output.split("\n").map(&:strip).join("\n")
          else
            :none
          end
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
