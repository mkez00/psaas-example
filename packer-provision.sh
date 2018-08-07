#!/bin/bash

# Create required directories
mkdir /var/psaas-devops-exercise /etc/psaas-devops-exercise

# Install required tools
apt update
apt upgrade -y
apt install docker.io unzip nginx jq -y

# Copy service files for auto upgrade and start timer
cp /home/vagrant/update.sh /etc/psaas-devops-exercise/update.sh
cp /home/vagrant/init.sh /etc/psaas-devops-exercise/init.sh
cp /home/vagrant/psaas-update* /etc/systemd/system/
systemctl daemon-reload
systemctl enable psaas-update.timer
systemctl start psaas-update.timer

# Configure nginx to act as reverse proxy for web application.  Also copy configuration endpoint which service config files for nginx
cp /home/vagrant/default /etc/nginx/sites-available/default
cp /home/vagrant/configuration /etc/nginx/sites-available/configuration
ln -s /etc/nginx/sites-available/configuration /etc/nginx/sites-enabled/
systemctl restart nginx

# Copy configuration scripts
cp /home/vagrant/psaas-cli.sh /etc/psaas-devops-exercise/psaas-cli.sh