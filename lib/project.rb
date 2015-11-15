require 'json'
require 'luhn'

class Project
  attr_reader :name, :goal, :backers

  def initialize(name="New_Project", goal=1, backers=[])
    validate_name(name)
    validate_money(goal)
    @name = name
    @goal = goal
    @backers = backers
  end

  def add_backer(name, card, pledge)
    validate_card(card, name)
    validate_money(pledge)
    validate_name(name)
    @backers << [name, card, pledge]
  end

  def pledge_total
    @backers.reduce(0){ |memo, backer| memo + backer[2] }
  end

  def to_s
    @backers.each do |backer, card, pledge|
      puts "-- #{backer} backed for $#{pledge}"
    end
    if self.pledge_total < @goal
      puts "#{name} needs $#{@goal-pledge_total} more dollars to be successful"
    else
      puts "#{name} is successful!"
    end
  end

  def to_json
    [name, goal, backers].to_json
  end

  def save
    File.open("data/#{name}.json", 'w') { |file| file.write(self.to_json) }
  end

  def self.load(project_name)
    return self.new(*JSON.parse(File.read("data/#{project_name}.json")))
  end

  def self.list_projects
    Dir.glob('data/*.json').collect{ |f| f.split('/')[1].split('.')[0] }
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
    Project.list_projects.each do |name|
      proj = Project.load(name)
      proj.backers.each do |backer, card, pledge|
        if card_number == card && backer != backer_name
          raise "Card already in use by another backer"
        end
      end
    end
  end

end
