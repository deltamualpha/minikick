require './lib/project'
require 'json'

RSpec.describe Project do
  describe "Project" do
    it "creates a new Project" do
      project = Project.new 'foo_bar-123', 1
      expect(project.name).to eq('foo_bar-123')
      expect(project.goal).to eq(1)
    end

    it "adds a backer" do
      project = Project.new 'foobar', 1
      project.add_backer 'John', 4111111111111111, 50
      backer = project.backers[0]
      expect(backer.name).to eq("John")
      expect(backer.card).to eq(4111111111111111)
      expect(backer.pledge).to eq(50)
    end

    xit "rejects duplicate backer credit card numbers" do
      project = Project.new('foobar', 1)
      project.add_backer 'Mike', 4111111111111111, 50
      expect{ project.add_backer 'John', 4111111111111111, 50 }.to raise_error
    end

    it "serializes to JSON" do
      expect( Project.new('foo_bar', 1, [["john", 4111111111111111, 50]]).to_json )
        .to eq('["foo_bar",1,[["john",4111111111111111,50]]]')
    end

  end
end