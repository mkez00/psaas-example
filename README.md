Overview
=

PSaas Exercise.  In progress..

Auto Upgrade
-

The appliance will automatically poll the master branch of the GitHub repository for changes.  When a new commit is applied to master the appliance will automatically upgrade the Docker image and redeploy the application.  This service is invoked every 60 seconds.

Testing with Vagrant
=

To test the solution with Vagrant:

1) Clone/download the repo
2) Run `vagrant up` from root of project (this step assumes you already have Vagrant installed)
3) The application will not be available for roughly 5 minutes after provisioning completes.  This is because the auto upgrade service will be running and building the Docker image.  Run `curl 192.168.56.100` to see the intended output `Hello World`

Check the status of the initial build:

1) Run `vagrant ssh` from project root
2) Run `sudo systemctl status psaas-update.service` to see status of upgrade job
