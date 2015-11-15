require 'luhn'
require 'json'
require './lib/project'

class Backer
  attr_reader :name, :card, :pledge

  def initialize(name, card, pledge)
    validate_card(card, name)
    validate_money(pledge)
    validate_name(name)
    @name, @card, @pledge = name, card, pledge
  end

  def to_json(options = {})
    [name, card, pledge].to_json
  end

  def self.list_backers
    Project.list_projects.reduce([]) do |memo, name|
      memo + JSON.parse(File.read("data/#{name}.json"))[2]
    end
  end

  private

  def validate_name(name)
    if name.length < 4 || name.length > 20
      raise "Name length error: name must be between 4 and 20 characters."
    end
    if name =~ /[^a-zA-Z0-9\-_]+/
      raise "Name error: name must contain only alphanumeric characers, dashes, and underscores."
    end
  end

  def validate_money(goal)
    if !goal.is_a? Numeric
      raise "Goal error: amount provided is not a number"
    end
  end

  def validate_card(card_number, backer_name)
    if !Luhn.valid? card_number
      raise "Card Validation Error: card provided does not pass Luhn-10 check"
    end
    if card_number.to_s.length > 19 
      raise "Card Validation Error: card number too long"
    end
    Backer.list_backers.each do |backer, card, pledge|
      if card_number == card && backer != backer_name
        raise "Card already in use by another backer"
      end
    end
  end
  
end