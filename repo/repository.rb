require_relative 'repository/base_repository'
require_relative 'repository/git_repository'
require_relative 'repository/cache'

module Geronimo
  module Repository
    def self.from_path(dirname)
      if git = Geronimo::Repository::GitRepository.find_from_path(dirname)
        return git
      end
    end
  end
end
