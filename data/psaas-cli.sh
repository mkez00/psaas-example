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
	sed -i '/ssl on;/c\ssl off;' /etc/nginx/sites-available/default
	sed -i 's/ssl_certificate/#ssl_certificate/g' /etc/nginx/sites-available/default
	nginx -s reload
	echo "SSL Disabled Successfully"
elif [ $1 = "enable-ssl" ]; then
	echo "Enabling SSL"
	sed -i '/ssl off;/c\ssl on;' /etc/nginx/sites-available/default
	sed -i 's/#ssl_certificate/ssl_certificate/g' /etc/nginx/sites-available/default
	nginx -s reload
	echo "SSL Enabled Successfully"
elif [ $1 = "copy-cert" ]; then
	echo "Copying Certificate and Private Key"
	mv $2 /etc/nginx/ssl/mycert.pem
	mv $3 /etc/nginx/ssl/mykey.pem
	echo "Certificate and Private Key Successfully Copied"
else
	echo "No option specified.  Options available:"
	echo "update-port [port-number]"
	echo "copy-cert [certificate-file-location] [private-key-file-location]"
	echo "disable-ssl"
	echo "enable-ssl"
fi

