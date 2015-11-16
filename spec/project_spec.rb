require './lib/project'
require './lib/backer' # probably a bad sign
require 'json'

RSpec.describe Project do
  describe "Project" do
    before(:each) do
      Backer.class_variable_set :@@all_backers, []
      Project.class_variable_set :@@all_projects, []
    end

    it "creates a new Project" do
      project = Project.new 'foo_bar-123', 1
      expect(project.name).to eq('foo_bar-123')
      expect(project.goal).to eq(1)
    end

    it "adds a backer" do
      project = Project.new 'foobar', 1
      project.add_backer 'John', 4111111111111111, 50
      backer = project.backers[0]
      expect([backer.name, backer.card, backer.pledge]).to eq(['John', 4111111111111111, 50])
    end

    it "rejects duplicate backer credit card numbers" do
      project = Project.new('foobar', 1)
      project.add_backer 'Mike', 4111111111111111, 50
      expect{ project.add_backer 'John', 4111111111111111, 50 }.to raise_error
    end

    it "returns all projects a backer has pledged to" do
      expect(Project.find_backer_projects("Mike").size).to eq(0)
      project = Project.new 'foobar', 1
      project.add_backer 'John', 4111111111111111, 50
      project = Project.new 'foobar2', 1
      project.add_backer 'John', 4111111111111111, 50
      project = Project.new 'foobar3', 1
      project.add_backer 'Mark', 5555555555554444, 50
      expect(Project.find_backer_projects("John").size).to eq(2)
    end

    it "serializes to JSON" do
      expect( Project.new('foo_bar', 1, [["john", 4111111111111111, 50]]).to_json )
        .to eq('["foo_bar",1,[["john",4111111111111111,50]]]')
    end

  end
end