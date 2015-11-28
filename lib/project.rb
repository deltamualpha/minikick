require 'json'
require './lib/backer'
require './lib/utilities'

class Project
  attr_reader :name, :goal, :backers

  @@all_projects = []

  def initialize(name="New_Project", goal=1, backers=[])
    Utilities.validate_name(name)
    Utilities.validate_money(goal)
    
    @name, @goal, @backers = name, goal, []
    backers.each{ |backer| self.add_backer(*backer) }
    @@all_projects << self
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

  def self.all_projects
    @@all_projects
  end

  def self.find_backer_projects(backer_name)
    Project.all_projects.select do |project|
      project.backers.any? do |backer| 
        backer.name == backer_name
      end
    end
  end


end
