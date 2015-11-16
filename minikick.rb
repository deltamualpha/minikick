#!/usr/bin/ruby

require './lib/database'
require './lib/interface'

interface = Interface.new
db = Database.instance
db.load

begin
  case ARGV.shift
  when "project"
    interface.project(db, ARGV)
  when "back"
    interface.back(db, ARGV)
  when "list"
    interface.list(db, ARGV)
  when "backer"
    interface.backer(db, ARGV)
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
rescue Exception => e
  printf "ERROR: %s\n", e
end
