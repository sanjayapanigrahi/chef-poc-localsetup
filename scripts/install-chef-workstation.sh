#!/bin/bash
echo "#################################################Workstation Installation  - START#################################################"
sudo apt-get update
sudo apt-get install tree
wget https://packages.chef.io/files/stable/chef-workstation/21.10.640/ubuntu/20.04/chef-workstation_21.10.640-1_amd64.deb
dpkg -i chef-workstation_21.10.640-1_amd64.deb
echo "###########################################Workstation Installation  - SUCCESSFULLY DONE###########################################"
sudo cp /vagrant/ZscalerRootCertificate.crt /home/vagrant/chef-starter/chef-repo/.chef/trusted_certs