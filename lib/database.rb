require 'json'
require 'singleton'
require 'fileutils'
require './lib/project'

class Database
  include Singleton

  attr_reader :projects

  def initialize(projects={})
    FileUtils.mkdir_p('data')
    @projects = projects
  end

  def project(name='New_Project', goal=1, backers=[])
    if @projects[name]
      @projects[name]
    else
      @projects[name] = Project.new(name, goal, backers)
    end
  end

  def save
    File.open("data/database.json", 'w') { |f| f.write(self.to_json) }
  end

  def load
    begin
      db = File.read("data/database.json")
    rescue
      db = "{}"
    end
    JSON.parse(db).each do |_, project|
      self.project(*project)
    end
  end

  def to_json(*)
    @projects.to_json
  end

end
