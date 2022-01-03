# chef-poc-localsetup
Use Case - Local Setup (Workstation, Server and Nodes) along with Cookbook with Load Balancer (HA Proxy) on one Node to maintain load balancing Web App (Apache2) on two nodes.

# Pre-requisite
    - Vagrant
    - Oracle VM VirtualBox Manager
    - Git Bash
    - IDE (Visual COde Studio or Atom or any)

# Chef Server
## Hosted Chef Server (api.chef.io)
As of now we are using Hosted Chef Server (api.chef.io).
    -   Create an Account (User)
    -   Create an Organisation
    -   Download the "Chef-Starter" kit (Administrator --> Organisation --> Strater Kit)
## Local Chef Server
Work In Progress

## Chef Workstation:
To Configure Workstation, we are using Ubuntu server and the installation are done in automated way using Vagrant File and Shell Script.

```
$do_certs_update = <<-'SCRIPT'
echo "#################################################Copy SSL Root Certificate (Ubuntu)#################################################"
sudo cp /vagrant/ZscalerRootCertificate.crt /usr/local/share/ca-certificates
sudo update-ca-certificates --fresh
echo "#################################################CA Certificates Refreshed#################################################"
SCRIPT

$install_workstation = <<-'SCRIPT'
echo "#################################################Workstation Installation  - START#################################################"
sudo apt-get update
sudo apt-get install tree
wget https://packages.chef.io/files/stable/chef-workstation/21.10.640/ubuntu/20.04/chef-workstation_21.10.640-1_amd64.deb
dpkg -i chef-workstation_21.10.640-1_amd64.deb
echo "###########################################Workstation Installation  - SUCCESSFULLY DONE###########################################"
sudo cp /vagrant/ZscalerRootCertificate.crt /home/vagrant/chef-starter/chef-repo/.chef/trusted_certs
SCRIPT

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/hirsute64"

  config.vm.define "workstation" do |node|
    node.vm.hostname ="workstation"
    node.vm.network "private_network", ip:"192.168.1.10"
    config.vm.provider 'virtualbox' do |vm|
      vm.name = "workstation"
    end
    
    config.vm.synced_folder "../shared/", "/vagrant"
    config.vm.synced_folder "../workspace/", "/home/vagrant/chef-starter"
    config.vm.provision "shell", inline: $do_certs_update
    config.vm.provision "shell", inline: $install_workstation
  end
end
```


## Challenges
    - Issue-1 - "ERROR: Train::ClientError: Your SSH Agent has no keys added, and you have not specified a password or a key file"
    Solution : 
        ```eval `ssh-agent` ```
        ```ssh-add```
    - Issue-2 - 
    Solution :


    - Issue-3 - 
    Solution :

    - Issue-4 - 
    Solution :

    - Issue-5 - 
    Solution :
    
