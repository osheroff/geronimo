require_relative '../repository'

module Geronimo
  module Repository
    class RepositoryFile
      class <<self
        def get(filename)
          new(filename)
        end
      end

      attr_reader :repository, :filename, :basename, :dirname

      def initialize(filename)
        @filename = filename
        @basename = File.basename(filename)
        @dirname = File.dirname(filename)
        @repository = Geronimo::Repository.from_path(dirname)
      end

      def last_commit
        repository.last_commit(filename)
      end

      def author_info
        {most_commits: repository.most_commits(filename)}
      end

      def relative_path
        filename.sub(%r{^#{repository.base_path}/?}, '')
      end

      def related_files
        repository.related_files(filename)
      end
    end
  end
end



