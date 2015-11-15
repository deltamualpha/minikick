#!/bin/sh -x
# this is a sanity check based on the contents of minikick.md
./minikick.rb project Awesome_Sauce 500
./minikick.rb back John Awesome_Sauce 4111111111111111 50
./minikick.rb back Sally Awesome_Sauce 1234567890123456 10
./minikick.rb back Jane Awesome_Sauce 4111111111111111 50
./minikick.rb back Jane Awesome_Sauce 5555555555554444 50
./minikick.rb list Awesome_Sauce
./minikick.rb back Mary Awesome_Sauce 5474942730093167 400
./minikick.rb list Awesome_Sauce
./minikick.rb backer John
rm data/Awesome_Sauce.json