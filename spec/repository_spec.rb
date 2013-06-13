require_relative '../repo/repository'

describe 'Geronimo::Repository' do
  let(:filepath) { File.expand_path(File.dirname(__FILE__)) }

  describe "from_path" do
    it "returns a GitRepository" do
      Geronimo::Repository.from_path(filepath).should be_instance_of Geronimo::Repository::GitRepository
    end
  end

  describe "GitRepository" do
    let (:gitrepo) { Geronimo::Repository.from_path(filepath) }
    let (:examplefile) { File.dirname(__FILE__) }

    it "can answer stuff about last_commit" do
      c = gitrepo.last_commit(examplefile)
      c.should_not be_nil
    end

    it "can answer stuff about authors" do
      c = gitrepo.most_commits(examplefile)
      c.size.should >= 1
    end

    it "can get related files" do
      c = gitrepo.related_files(examplefile)
    end
  end
end
