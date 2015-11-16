# One class to handle all the switching logic

class Interface
  def project(db, args)
    arg_check(args, 2)
    project_name, goal = args

    if !db.projects[project_name]
      db.project(project_name, goal.to_f)

      if db.save
        printf "Added %s project with target of $%.2f\n", project_name, goal
      else
        printf "Failure creating project.\n"
      end

    else
      printf "Project already exists.\n"
    end
  end

  def back(db, args)
    arg_check(args, 4)
    backer, project_name, credit_card_number, amount = args

    if db.projects[project_name]
      db.projects[project_name].add_backer backer, credit_card_number, amount.to_f

      if db.save
        printf "%s backed project %s for $%.2f\n", backer, project_name, amount
      else
        printf "Failure saving pledge.\n"
      end

    else
      printf "Unknown project.\n"
    end
  end

  def list(db, args)
    arg_check(args, 1)
    project_name = args[0]

    if db.projects[project_name]
      proj = db.projects[project_name]

      proj.backers.each do |backer|
        printf "-- %s backed for $%.2f\n", backer.name, backer.pledge
      end

      remaining = proj.goal-proj.pledge_total
      if remaining > 0
        printf "%s needs $%.2f more dollars to be successful\n", project_name, remaining
      else
        printf "%s is successful!\n", project_name
      end

    else
      printf "Unknown Project.\n"
    end
  end

  def backer(_, args)
    arg_check(args, 1)
    backer_name = args[0]

    projects = Project.find_backer_projects(backer_name)
    if projects
      # I don't like these nested eaches. Is there a better way?
      projects.each do |name, project|
        project.backers.each do |backer| 
          if backer.name == backer_name
            printf "-- Backed %s for $%.2f\n", name, backer.pledge
          end
        end
      end

    else
      printf "No projects for that backer found.\n"
    end
  end

  private

  def arg_check(args, count)
    if args.length != count
      printf "Invalid argument list\n"
      exit
    end
  end

end