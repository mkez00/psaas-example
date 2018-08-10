#!/bin/bash

# Are we booting the appliance for the first time
if [ ! -f /var/psaas-devops-exercise/.bootstrap ]; then
        echo "Bootstrapping appliance"
        touch /var/psaas-devops-exercise/.bootstrap

        # Update default config to the existing default config and restart nginx
        # Fetch subnet cidr from host-only network interface
		cidr=$(ip addr | grep enp0s8 | grep -oE '((1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])\.){3}(1?[0-9][0-9]?|2[0-4][0-9]|25[05])/[0-9][0-9]')
		
		# store IP address to prevent copying wrong config
		myip=$(echo $cidr | grep -oE '((1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])\.){3}(1?[0-9][0-9]?|2[0-4][0-9]|25[05])')

		# use nmap to get all nodes available in subnet
		ips=$(nmap -n -sP $cidr | grep -oE '((1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])\.){3}(1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])')
		
		# loop through all nodes in subnet
		for x in $ips
		do
				# do not use local address
		        if [ $x != $myip ]; then
		        		# is the node serving on the dedicated port
		                status=$(curl -s -o /dev/null -w "%{http_code}" -m 5 $x:8888)
		                if [ $status -eq "200" ]; then

		                		# copy the nginx server block
		                		echo "Found existing config at: " $x
		                        wget $x:8888 -O /etc/nginx/sites-available/index.html
        						mv /etc/nginx/sites-available/index.html /etc/nginx/sites-available/default

        						# Download certificate
        						echo "Downloading Certificate"
        						wget $x:8888/ssl/mycert.pem -O /etc/nginx/ssl/mycert.html
        						mv /etc/nginx/ssl/mycert.html /etc/nginx/ssl/mycert.pem

        						# Download private key (this should be more secure in a real production environment)
        						echo "Downloading Private Key"
        						wget $x:8888/ssl/mykey.pem -O /etc/nginx/ssl/mykey.html
								mv /etc/nginx/ssl/mykey.html /etc/nginx/ssl/mykey.pem
		                fi
		        fi
		done

		# Reload nginx with new settings applied
        nginx -s reload
fi