require 'luhn'
require 'json'
require './lib/database'
require './lib/utilities'

class Backer
  attr_reader :name, :card, :pledge

  def initialize(name, card, pledge)
    Utilities.validate_card(card)
    Utilities.validate_money(pledge)
    Utilities.validate_name(name)
    Utilities.validate_pledge(card, pledge)
    @name, @card, @pledge = name, card, pledge
  end

  def to_json(options = {})
    [name, card, pledge].to_json
  end

  def self.find_backer_projects(backer_name)
    # this is sort of clever: reduce over the list of backers,
    # flipping the t/f switch if a match is found.
    # the boolean then feeds the outer #select.
    Database.instance.projects.select do |name, project|
      project.backers.reduce(false) do |memo, backer| 
        memo || backer.name == backer_name
      end
    end
  end

end