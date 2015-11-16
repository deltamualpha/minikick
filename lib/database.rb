require 'json'
require 'singleton'
require './lib/project'

class Database
  include Singleton

  attr_reader :projects

  def initialize(projects={})
    if !File.directory?('data')
      Dir.mkdir('data')
    end
    if !File.exist?('data/database.json')
      file_save("data/database.json", '{}')
    end
    @projects = {}
  end

  def project(name='New_Project', goal=1, backers=[])
    if @projects[name]
      @projects[name]
    else
      @projects[name] = Project.new(name, goal, backers)
    end
  end

  def save
    file_save("data/database.json", self.to_json)
  end

  def load
    JSON.parse(File.read("data/database.json")).each do |name, project|
      self.project(*project)
    end
  end

  def to_json(options={})
    @projects.to_json
  end

  private

  def file_save(file, content)
    File.open(file, 'w') { |f| f.write(content) }
  end

end