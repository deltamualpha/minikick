#!/usr/bin/ruby

require './lib/project'

case ARGV.shift
when "project"
  if ARGV.length != 2
    puts "Invalid argument list"
    exit
  end
  project_name, goal = ARGV
  if Project.list_projects.include?(project_name)
    puts "A project already exists with that name."
  elsif goal == '' || goal.nil?
    puts "No goal provided."
  else
    if Project.new(project_name, goal.to_f).save
      puts "Added #{project_name} project with target of $#{goal}"
    else
      puts "Unknown failure saving project."
    end
  end
when "back"
  backer, project_name, credit_card_number, amount = ARGV
  if Project.list_projects.include?(project_name)
    proj = Project.load(project_name)
    proj.add_backer backer, credit_card_number, amount.to_f
    if proj.save
      puts "#{backer} backed project #{project_name} for $#{amount}"
    else
      puts "Unknown failure saving pledge."
    end
  else
    puts "Unknown project."
  end
when "list"
  project_name = ARGV[0]
  if Project.list_projects.include?(project_name)
    Project.load(project_name).to_s
  else
    puts "Unknown Project."
  end
when "backer"
  backer_name = ARGV[0]
  if backer_name
    Project.list_projects.each do |name|
      proj = Project.load(name)
      proj.backers.each do |backer, card, pledge|
        if backer_name == backer
          puts "-- backed #{name} for #{pledge}"
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