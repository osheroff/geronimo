require_relative 'editor_file'

module Geronimo
  module Server
    class EditorState
      def initialize(glob="/tmp/geronimo.*")
        @glob = glob
      end

      attr_reader :files
      def refresh!
        @files = Dir.glob("/tmp/geronimo.*").map do |f|
          next if f =~ /commands$/
          info = JSON.parse(File.read(f))
          EditorFile.new(info.merge('last_activity' => File.mtime(f)))
        end.compact.select(&:active?).uniq { |f| f.filename }.sort_by { |f| -f.last_activity.to_i }
      end

      def hash
        @files.hash
      end
    end
  end
end
