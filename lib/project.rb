require 'json'
require './lib/backer'

class Project
  attr_reader :name, :goal, :backers

  def initialize(name="New_Project", goal=1, backers=[])
    validate_name(name)
    validate_money(goal)
    @name, @goal, @backers = name, goal, []
    backers.each{ |backer| self.add_backer(*backer) }
  end

  def add_backer(name, card, pledge)
    @backers << Backer.new(name, card, pledge)
  end

  def pledge_total
    @backers.reduce(0){ |memo, backer| memo + backer.pledge }
  end

  def to_json(options = {})
    [name, goal, backers].to_json
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

end
