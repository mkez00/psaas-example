#!/bin/bash

# Create required directories
mkdir /var/psaas-devops-exercise /etc/psaas-devops-exercise

# Install required tools
apt update
apt upgrade -y
apt install docker.io unzip nginx jq curl nmap -y

# create ssl directory in nginx directory and empty files
mkdir /etc/nginx/ssl
touch /etc/nginx/ssl/mycert.pem /etc/nginx/ssl/mykey.pem

# Copy service files for auto upgrade and start timer
cp /home/vagrant/update.sh /etc/psaas-devops-exercise/update.sh
cp /home/vagrant/init.sh /etc/psaas-devops-exercise/init.sh
cp /home/vagrant/psaas-update* /etc/systemd/system/
cp /home/vagrant/psaas-startup* /etc/systemd/system/
cp /home/vagrant/01-netcfg.yaml /etc/netplan/

systemctl daemon-reload
systemctl enable psaas-update.timer
systemctl enable psaas-startup.service

# Configure nginx to act as reverse proxy for web application.  Also copy configuration endpoint which service config files for nginx
cp /home/vagrant/default /etc/nginx/sites-available/default
cp /home/vagrant/configuration /etc/nginx/sites-available/configuration
ln -s /etc/nginx/sites-available/configuration /etc/nginx/sites-enabled/

# Copy configuration scripts
cp /home/vagrant/psaas-cli.sh /etc/psaas-devops-exercise/psaas-cli.sh

# Due to slow build of default web application Docker image, baking it into appliance for less waiting during demo
wget https://github.com/auth0/psaas-devops-exercise/archive/master.zip -P /etc/psaas-devops-exercise/
unzip -o /etc/psaas-devops-exercise/master.zip -d /etc/psaas-devops-exercise/
cd /etc/psaas-devops-exercise/psaas-devops-exercise-master
docker build -t auth0/psaas-devops-exercise:latest .