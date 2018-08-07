#!/bin/bash

if [ $1 = "update-port" ]; then
	echo "Updating Port"
	if [ $2 = "8888" ]; then
		echo "Port 8888 is reserved"
	else
		sed -i '/listen/c\listen '"$2"';' /etc/nginx/sites-available/default
		nginx -s reload
		echo "Port Updated Successfully"
	fi
elif [ $1 = "disable-ssl" ]; then
	echo "Disabling SSL"
	sed -i '/ssl/c\' /etc/nginx/sites-available/default
	nginx -s reload
	echo "SSL Disabled Successfully"
else
	echo "No option specified.  Options available:"
	echo "update-port [port-number]"
	echo "disable-ssl"
	echo "enable-ssl [path-to-cert] [path-to-private-key]"
fi

