require './lib/project'
require 'json'

RSpec.describe Project do
  describe "Project" do
    it "creates a new Project" do
      project = Project.new 'foo_bar-123', 1
      expect(project.name).to eq('foo_bar-123')
      expect(project.goal).to eq(1)
    end

    it "validates project name length" do
      expect{ Project.new 'foo', 1 }.to raise_error
      expect{ Project.new 'foooooooooooooooooooo', 1 }.to raise_error
    end

    it "rejects invalid project names" do
      expect{ Project.new 'foo bar', 1 }.to raise_error
      expect{ Project.new '💩', 1 }.to raise_error
    end

    it "adds a backer" do
      project = Project.new 'foobar', 1
      project.add_backer 'John', 4111111111111111, 50
      expect(project.backers[0]).to eq(["John", 4111111111111111, 50])
    end

    it "validates backer credit card numbers" do
      project = Project.new('foobar', 1)
      expect{ project.add_backer 'John', 1234567890123456, 50 }.to raise_error
    end

    it "serializes to JSON" do
      expect( Project.new('foo_bar', 1, [["john", 4111111111111111, 50]]).to_json )
        .to eq('["foo_bar",1,[["john",4111111111111111,50]]]')
    end

  end
end