require 'luhn'
require './lib/database'

class Utilities
  def self.validate_name(name)
    if name.length < 4 || name.length > 20
      raise "Name must be between 4 and 20 characters."
    end
    if name =~ /[^a-zA-Z0-9\-_]+/
      raise "Name must contain only alphanumeric characers, dashes, and underscores."
    end
  end

  def self.validate_money(value)
    if !value.is_a? Numeric
      raise "Amount provided is not a number"
    end
    if value <= 0
      raise "All monetary amounts must be positive"
    end
  end

  def self.validate_card(card_number)
    if !Luhn.valid?(card_number) || card_number.to_s.length > 19
      raise "This card is invalid"
    end
  end

  # Annyoingly, this works but isn't easily testable
  # because of how the singleton works.
  def self.validate_pledge(card_number, backer_name)
    Database.instance.projects.each do |_, project|
      project.backers.each do |backer|
        if card_number == backer.card && backer_name != backer.name
          raise "That card has already been added by another user!"
        end
      end
    end
  end

end