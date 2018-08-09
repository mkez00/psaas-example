Overview
=

Port Configuration
-

Login to the appliance and run the following to update the port the application is being served on: `sudo sh /etc/psaas-devops-exercise/psaas-cli.sh update-port <PORT_NUMBER>`

Copy Certificate and Private Key
-

To update/copy your signed certificate to the appliance, run the following commands:

1) Secure copy the certificate to the appliance: `scp <CERTIFICATE> vagrant@<IP_ADDRESS_OF_APPLIANCE>:/home/vagrant`
2) Secure copy the private key to the appliance: `scp <PRIVATE_KEY> vagrant@<IP_ADDRESS_OF_APPLIANCE>:/home/vagrant`
3) Connect to the appliance and run the copy utility: `sudo sh /etc/psaas-devops-exercise/psaas-cli.sh copy-cert <CERTIFICATE> <PRIVATE_KEY>`

Enable SSL
-

To enable SSL for the appliance login to the appliance and run the following: `sudo sh /etc/psaas-devops-exercise/psaas-cli.sh enable-ssl`

Disable SSL
-

To disable SSL for the appliance login to the appliance and run the following: `sudo sh /etc/psaas-devops-exercise/psaas-cli.sh disable-ssl`

Migration Information
-

After building/downloading a new OVA you can provision the appiance on the same network as the legacy OVA.  On first boot the appliance will automatically scan for existing appliances and will automatically update the new appliance with the legacy appliance settings.  These settings include:

- Port number
- SSL Settings

The appliance will expose its settings on port 8888 for future appliances to scan for and update from.

Auto Upgrade
-

The appliance will automatically poll the master branch of the GitHub repository for changes.  When a new commit is applied to master the appliance will automatically upgrade the Docker image and redeploy the application.  This service is invoked every 20 seconds.  The appliance deploys duplicate copies of the web application containers (bound to ports 8080, and 8081) and configures NGINX to act as a load balancer for these containers.  When the upgrade commences, rolling updates occur to each container offering high availability to the web application.

Building with Packer
=

To build the OVA with Packer run `packer build provision.json` from the project root

Testing with Vagrant
=

To test the solution with Vagrant:

1) Clone/download the repo
2) Run `vagrant up` from root of project (this step assumes you already have Vagrant installed)
3) The application will not be available for roughly 5 minutes after provisioning completes.  This is because the auto upgrade service will be running and building the Docker image.  Run `curl 192.168.56.100` to see the intended output `Hello World`

Check the status of the initial build:

1) Run `vagrant ssh` from project root
2) Run `sudo systemctl status psaas-update.service` to see status of upgrade job
