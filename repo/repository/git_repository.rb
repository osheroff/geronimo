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

      attr_reader :base_path, :git
      def initialize(base_path)
        @base_path = base_path
        @git = Git.open(@base_path)
      end

      def last_commit(filename)
        commits_for_file(filename).first
      end

      def commits_for_file(filename)
        @commits ||= @git.log(nil).object(filename)
      end

      def most_commits(filename, limit = nil)
        authors = commits_for_file(filename).map(&:author)

        grouped = authors.group_by(&:email).map do |email, author_array|
          {author: author_array.first, count: author_array.size}
        end

        sorted = grouped.sort do |a, b|
          b[:count] <=> a[:count]
        end

        limit ?  sorted[0..limit] : sorted
      end

      def related_files(filename)
        related = {}
        commits = commits_for_file(filename).map do |c|
          if c && c.parent
            begin
              related_files = Geronimo::Repository::Cache.cache("git/#{c.sha}/#{c.parent.sha}") do
                c.diff_parent.map(&:path)
              end
            rescue StandardError => e
              puts e
            end
          end
        end.compact
        commits.flatten.group_by { |c| c }.map do |k, v|
          {:filename => k, :count => v.size, :fullpath => @base_path + "/" + k}
        end.sort do |a, b|
          b[:count] <=> a[:count]
        end
      end
    end
  end
end
