#!/bin/bash

if [ ! -f /var/psaas-devops-exercise/.bootstrap ]; then
        echo "Bootstrapping appliance"
        touch /var/psaas-devops-exercise/.bootstrap

        # Update default config to the existing default config and restart nginx
        wget localhost:8888 -O /etc/nginx/sites-available/index.html
        mv /etc/nginx/sites-available/index.html /etc/nginx/sites-available/default
        nginx -s reload
fi