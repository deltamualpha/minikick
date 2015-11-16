#!/usr/bin/ruby

require './lib/database'

db = Database.instance
db.load

def arg_check(args, count)
  if args.length != count
    puts "Invalid argument list"
    exit
  end
end

case ARGV.shift
when "project"
  arg_check(ARGV, 2)
  project_name, goal = ARGV
  db.project(project_name, goal.to_f)
  if db.save
    puts "Added #{project_name} project with target of $#{goal}"
  end
when "back"
  arg_check(ARGV, 4)
  backer, project_name, credit_card_number, amount = ARGV
  if db.projects[project_name]
    db.projects[project_name].add_backer backer, credit_card_number, amount.to_f
    if db.save
      puts "#{backer} backed project #{project_name} for $#{amount}"
    else
      puts "Failure saving pledge."
    end
  else
    puts "Unknown project."
  end
when "list"
  arg_check(ARGV, 1)
  project_name = ARGV[0]
  if db.projects[project_name]
    proj = db.projects[project_name]
    proj.backers.each do |backer|
      puts "-- #{backer.name} backed for $#{backer.pledge}"
    end
    if proj.pledge_total < proj.goal
      puts "#{project_name} needs $#{proj.goal-proj.pledge_total} more dollars to be successful"
    else
      puts "#{project_name} is successful!"
    end
  else
    puts "Unknown Project."
  end
when "backer"
  arg_check(ARGV, 1)
  backer_name = ARGV[0]
  if backer_name
    Backer.find_backer_projects(backer_name).each do |name, project|
      project.backers.each do |backer| 
        if backer.name == backer_name
          puts "-- Backed #{name} for $#{backer.pledge}"
        end
      end
    end
  else
    puts "No backer provided."
  end
else
  puts "Minikick: a simple implementation of the logic of projects and pledges"
  puts "  project <project> <target amount>"
  puts "    create a new project"
  puts "  back <given name> <project> <credit card number> <backing amount>"
  puts "    back a give project"
  puts "  list <project>"
  puts "    show current status of a project"
  puts "  backer <given name>"
  puts "    list all projects a backer has pledged toward"
end