require 'json'
require './lib/backer'
require './lib/utilities'

class Project
  attr_reader :name, :goal, :backers

  def initialize(name="New_Project", goal=1, backers=[])
    Utilities.validate_name(name)
    Utilities.validate_money(goal)
    @name, @goal, @backers = name, goal, []
    backers.each{ |backer| self.add_backer(*backer) }
  end

  def add_backer(name, card, pledge)
    @backers << Backer.new(name, card, pledge)
  end

  def pledge_total
    @backers.reduce(0){ |memo, backer| memo + backer.pledge }
  end

  def to_json(*)
    [name, goal, backers].to_json
  end

end
