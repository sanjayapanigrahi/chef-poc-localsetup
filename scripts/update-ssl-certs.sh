#!/bin/bash
echo "#################################################Copy SSL Root Certificate (Ubuntu)#################################################"
sudo cp /vagrant/ZscalerRootCertificate.crt /usr/local/share/ca-certificates
sudo update-ca-certificates --fresh
echo "#################################################CA Certificates Refreshed#################################################"