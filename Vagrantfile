Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-18.04"
  config.vm.hostname = 'psaas'
  config.vm.network "private_network", ip: "192.168.56.100"
  config.vm.synced_folder "data", "/data"
  config.vm.provision "shell", inline: <<-SHELL
  		sudo su

  		# Install required tools
  		apt update
  		apt install docker.io unzip nginx -y

  		# Fetch web application
  		wget https://github.com/auth0/psaas-devops-exercise/archive/master.zip
  		unzip master.zip
  		cd psaas-devops-exercise-master

  		# Build and run Docker application
  		docker build -t auth0/psaas-devops-exercise .
  		docker run -p 8080:3000 -d auth0/psaas-devops-exercise

  		# Configure nginx to act as reverse proxy for web application
  		cp /data/default /etc/nginx/sites-available/default
  		systemctl restart nginx

  SHELL
end
