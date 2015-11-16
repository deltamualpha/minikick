require './lib/utilities'

RSpec.describe Utilities do
  describe "Utilities" do
    it "validates a name's length" do
      expect{ Utilities.validate_name "foo" }.to raise_error
      expect{ Utilities.validate_name 'foooooooooooooooooooo' }.to raise_error
      expect{ Utilities.validate_name "foobar" }.to_not raise_error
    end

    it "rejects invalid names" do
      expect{ Utilities.validate_name 'foo bar' }.to raise_error
      expect{ Utilities.validate_name '💩' }.to raise_error
    end

    it "validates a credit card number" do
      expect{ Utilities.validate_card 1234567890123456 }.to raise_error
      expect{ Utilities.validate_card 4111111111111111 }.to_not raise_error
    end

    it "validates a goal or pledge" do
      expect{ Utilities.validate_money 12 }.to_not raise_error
      expect{ Utilities.validate_money 12.50 }.to_not raise_error
      expect{ Utilities.validate_money(-12) }.to raise_error
      expect{ Utilities.validate_money "12" }.to raise_error
      expect{ Utilities.validate_money "foobar" }.to raise_error
      expect{ Utilities.validate_money 0 }.to raise_error
    end
  end
end