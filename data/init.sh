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
		                        wget $x:8888 -O /etc/nginx/sites-available/index.html
        						mv /etc/nginx/sites-available/index.html /etc/nginx/sites-available/default
		                fi
		        fi
		done

        nginx -s reload
fi