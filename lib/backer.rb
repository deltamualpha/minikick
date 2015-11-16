require 'luhn'
require 'json'
require './lib/project'
require './lib/database'

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
    if !Luhn.valid? card_number || card_number.to_s.length > 19
      raise "This card is invalid"
    end
    Database.instance.projects.each do |name, project|
      project.backers.each do |backer|
        if card_number == backer.card && backer.name != backer_name
          raise "That card has already been added by another user!"
        end
      end
    end
  end
  
end