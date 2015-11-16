require './lib/backer'

RSpec.describe Backer do
  describe "Backer" do
    it "creates a new Backer" do
      backer = Backer.new 'foo_bar-123', 4111111111111111, 50
      expect(backer.name).to eq('foo_bar-123')
      expect(backer.card).to eq(4111111111111111)
      expect(backer.pledge).to eq(50)
    end

  end
end