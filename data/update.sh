#!/bin/bash

echo "Checking for update"

# Get latest commit from master branch and compare to the last one stored when application was last built
latesthash=$(curl https://api.github.com/repos/auth0/psaas-devops-exercise/branches/master | jq '.commit.sha')
lasthash=$(cat /var/psaas-devops-exercise/lasthash.log)

if [ "$latesthash" != "$lasthash" ]; then
	echo "Update required"

	# Fetch web application source
  	wget https://github.com/auth0/psaas-devops-exercise/archive/master.zip -P /etc/psaas-devops-exercise/

  	# Update stored commit hash with the most recent on source repo
  	curl https://api.github.com/repos/auth0/psaas-devops-exercise/branches/master | jq '.commit.sha' >> /var/psaas-devops-exercise/lasthash.log

  	# Unzip the source code
  	unzip -o /etc/psaas-devops-exercise/master.zip -d /etc/psaas-devops-exercise/
  	cd /etc/psaas-devops-exercise/psaas-devops-exercise-master


  	# Build Docker web application
  	docker build -t auth0/psaas-devops-exercise:latest .

	# Stop and remove all running containers (this isn't ideal)
  	docker stop $(docker ps -a -q)
	docker rm $(docker ps -a -q)

	# Run latest version of web application
  	docker run -p 8080:3000 -d auth0/psaas-devops-exercise:latest

  	echo "Update complete"
else
	echo "No update required"
fi

