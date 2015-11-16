require 'luhn'
require 'json'
require './lib/database'
require './lib/utilities'

class Backer
  attr_reader :name, :card, :pledge

  @@all_backers = []

  def initialize(name, card, pledge)
    # boy, this looks like an anti-pattern
    Utilities.validate_card(card)
    Utilities.validate_money(pledge)
    Utilities.validate_name(name)
    Utilities.validate_pledge(card, name)

    @@all_backers << {"name" => name, "card" => card, "pledge" => pledge}
    @name, @card, @pledge = name, card, pledge
  end

  def to_json(*)
    [name, card, pledge].to_json
  end

  def self.all_backers
    @@all_backers
  end

end