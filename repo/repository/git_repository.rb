require 'git'
require_relative 'base_repository'

module Geronimo
  module Repository
    class GitRepository < BaseRepository
      class <<self
        def find_git_base(dirname)
          while dirname != '/'
            if File.directory?(dirname + "/.git")
              return dirname
            end
            dirname = File.dirname(dirname)
          end
          nil
        end

        def find_from_path(dirname)
          if gitbase = find_git_base(dirname)
            new(gitbase)
          else
            nil
          end
        end
      end

      attr_reader :gitbase, :git
      def initialize(gitbase)
        @gitbase = gitbase
        @git = Git.open(gitbase)
      end

      def last_commit(filename)
        @git.log(1).object(filename).first
      end
    end
  end
end
