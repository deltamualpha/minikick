require 'json'
require 'singleton'
require './lib/project'

class Database
  include Singleton

  attr_reader :projects

  def initialize(projects={})
    @projects = {}
  end

  def project(name="New_Project", goal=1, backers=[])
    if @projects[name]
      @projects[name]
    else
      @projects[name] = Project.new(name, goal, backers)
    end
  end

  def save
    File.open("data/database.json", 'w') { |file| file.write(self.to_json) }
  end

  def load
    JSON.parse(File.read("data/database.json")).each{ |name, project|
      self.project(*project)
    }
  end

  def to_json(options={})
    @projects.to_json
  end

end