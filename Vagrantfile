Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-18.04"
  config.vm.hostname = 'psaas'
  config.vm.network "private_network", ip: "192.168.56.100"
  config.vm.synced_folder "data", "/data"
  config.vm.provision "shell", inline: <<-SHELL
  		sudo su

  		# Create required directories
  		mkdir /var/psaas-devops-exercise /etc/psaas-devops-exercise

  		# Install required tools
  		apt update
  		apt install docker.io unzip nginx jq -y

  		# Copy service files for auto upgrade and start timer
  		cp /data/update.sh /etc/psaas-devops-exercise/update.sh
  		cp /data/psaas-update* /etc/systemd/system/
  		systemctl daemon-reload
  		systemctl enable psaas-update.timer
  		systemctl start psaas-update.timer

  		# Configure nginx to act as reverse proxy for web application.  Also copy configuration endpoint which service config files for nginx
  		cp /data/default /etc/nginx/sites-available/default
  		cp /data/configuration /etc/nginx/sites-available/configuration
  		ln -s /etc/nginx/sites-available/configuration /etc/nginx/sites-enabled/
  		systemctl restart nginx

  		# Copy configuration scripts
  		cp /data/psaas-cli.sh /etc/psaas-devops-exercise/psaas-cli.sh

  SHELL
end
