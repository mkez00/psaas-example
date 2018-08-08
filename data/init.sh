#!/bin/bash

if [ ! -f /var/psaas-devops-exercise/.bootstrap ]; then
        echo "Bootstrapping appliance"
        touch /var/psaas-devops-exercise/.bootstrap

        # Update default config to the existing default config and restart nginx
		cidr=$(ip addr | grep enp0s8 | grep -oE '((1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])\.){3}(1?[0-9][0-9]?|2[0-4][0-9]|25[05])/[0-9][0-9]')
		myip=$(echo $cidr | grep -oE '((1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])\.){3}(1?[0-9][0-9]?|2[0-4][0-9]|25[05])')
		ips=$(nmap -n -sP $cidr | grep -oE '((1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])\.){3}(1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])')
		for x in $ips
		do
		        if [ $x != $myip ]; then
		                status=$(curl -s -o /dev/null -w "%{http_code}" -m 5 $x:8888)
		                if [ $status -eq "200" ]; then
		                		echo "Found existing config at: " $x
		                        wget $x:8888 -O /etc/nginx/sites-available/index.html
        						mv /etc/nginx/sites-available/index.html /etc/nginx/sites-available/default

        						# download certificate
        						echo "Downloading Certificate"
        						wget $x:8888/ssl/mycert.pem -O /etc/nginx/ssl/mycert.html
        						mv /etc/nginx/ssl/mycert.html /etc/nginx/ssl/mycert.pem

        						# download private key (this should be more secure in a real production environment)
        						echo "Downloading Private Key"
        						wget $x:8888/ssl/mykey.pem -O /etc/nginx/ssl/mykey.html
								mv /etc/nginx/ssl/mykey.html /etc/nginx/ssl/mykey.pem
		                fi
		        fi
		done

        nginx -s reload
fi