module Geronimo
  module Server
    class EditorFile
      attr_reader :filename, :pid, :mtime
      def initialize(hash)
        @filename = hash['file']
        @pid = hash['pid']
        @uuid = hash['uuid']
        @mtime = File.mtime(@filename) rescue nil
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
        if !defined?(@repo_file)
          @repo_file = Geronimo::Repository::RepositoryFile.get(@filename)
        end
        @repo_file
      end
    end
  end
end
