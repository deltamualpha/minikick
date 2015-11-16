require './lib/backer'

RSpec.describe Backer do
  describe "Backer" do
    it "creates a new Backer" do
      backer = Backer.new 'foo_bar-123', 4111111111111111, 50
      expect(backer.name).to eq('foo_bar-123')
      expect(backer.card).to eq(4111111111111111)
      expect(backer.pledge).to eq(50)
    end

    it "validates backer name length" do
      expect{ Backer.new 'Jon', 4111111111111111, 50 }.to raise_error
      expect{ Backer.new 'foooooooooooooooooooo', 4111111111111111, 50  }.to raise_error
    end

    it "validates backer credit card numbers" do
      expect{ Backer.new 'John', 1234567890123456, 50 }.to raise_error
    end

  end
end