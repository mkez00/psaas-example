#!/bin/bash

roll_update(){
	container=$(docker ps | grep :$port | cut -d " " -f1)
  	docker stop $container
  	docker rm $container
  	docker run -p 127.0.0.1:$port:3000 -d auth0/psaas-devops-exercise:latest
}

echo "Checking for update"

# Get latest commit from master branch and compare to the last one stored when application was last built
latesthash=$(curl https://api.github.com/repos/auth0/psaas-devops-exercise/branches/master | jq '.commit.sha')
lasthash=$(cat /var/psaas-devops-exercise/lasthash.log)

if [ "$latesthash" != "$lasthash" ]; then
	echo "Update required"

	# Fetch web application source
  	wget https://github.com/auth0/psaas-devops-exercise/archive/master.zip -P /etc/psaas-devops-exercise/

  	# Update stored commit hash with the most recent on source repo
  	curl https://api.github.com/repos/auth0/psaas-devops-exercise/branches/master | jq '.commit.sha' > /var/psaas-devops-exercise/lasthash.log

  	# Unzip the source code
  	unzip -o /etc/psaas-devops-exercise/master.zip -d /etc/psaas-devops-exercise/
  	cd /etc/psaas-devops-exercise/psaas-devops-exercise-master

  	# Build Docker web application
  	docker build -t auth0/psaas-devops-exercise:latest .

  	# roll update to first container
  	port=8081
  	roll_update

  	# roll update to second container
  	port=8080
  	roll_update

  	echo "Update complete"
else
	echo "No update required"

	# If the docker container is not running (ie. after a restart).  Simply start it.  
	# This should be another SystemD service if it were to be done in a production environment.  For the sake of this exercise and not cluttering the 
	# repo too much, it will do the trick if the VM is rebooted.
	process=$(docker ps | grep auth0/psaas-devops-exercise)
	if [ -z "$process" ]; then
		# This assumes there is only one container running in Docker...can be dangerous but works for this example
		docker start $(docker ps -a -q)
	fi
fi

