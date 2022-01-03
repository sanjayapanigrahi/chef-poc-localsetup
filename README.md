# chef-poc-localsetup
# Use Case 
Local Setup (Workstation, Server and Nodes) along with Cookbook with Load Balancer (HA Proxy) on one Node to maintain load balancing Web App (Apache2) on two nodes.

# Pre-requisite
    - Vagrant
    - Oracle VM VirtualBox Manager
    - Git Bash
    - IDE (Visual COde Studio or Atom or any)

# Chef Server
## Hosted Chef Server (api.chef.io)
As of now we are using Hosted Chef Server (api.chef.io).
    - Create an Account (User)
    - Create an Organisation
    - Download the "Chef-Starter" kit (Administrator --> Organisation --> Strater Kit)
## Local Chef Server
Work In Progress

# Chef Node
To provision nodes, we are using Ubuntu server and the provision is done in automated way using Vagrant File.

## Provisioning and Login using Vagrant
-   Ubuntu Server Provisioning
    ```vagrantfile 
    Vagrant.configure("2") do |config|
        config.vm.box = "ubuntu/hirsute64"
    end
    ```
Once the Vagrant File is ready we can use ```vagrant up``` command for server Provisioning. And use ```vagrant ssh``` to login to the workstation 

# Chef Workstation:
To Configure Workstation, we are using Ubuntu server and the installation are done in automated way using Vagrant File and Shell Script.

## Provisioning and Login using Vagrant
-   Ubuntu Server Provisioning
    ```vagrantfile 
    Vagrant.configure("2") do |config|
        config.vm.box = "ubuntu/hirsute64"
        config.vm.synced_folder "../shared/", "/vagrant"
        config.vm.provision "shell", inline: $install_workstation
    end
    ```
Note: We can share the Files or Directory using ```synced_folder``` functionality of Vagrant for sharing purpose. This is usefull for sharing the STARTER_KIT we download from chef server.

- Workstation Installation
    ```shell
    $install_workstation = <<-'SCRIPT'
    wget https://packages.chef.io/files/stable/chef-workstation/21.10.640/ubuntu/20.04/chef-workstation_21.10.640-1_amd64.deb
    dpkg -i chef-workstation_21.10.640-1_amd64.deb
    SCRIPT
    ```
- Once the Vagrant File is ready we can use ```vagrant up``` command for server Provisioning and workstation installation.
- And use ```vagrant ssh``` to login to the workstation and validate if chef is install or not by using ```chef --version```

## Setting Starter Kit
- Copy the Starter Kit from /vagrant (synced_folder) and placed in /home/vagrant/ (~) folder and extract it.
- Navigate to "chef-starter/chef-repo"
- To connect with chefserver we need to fetch the trusted certificate by using knife command.
    ```knife ssl fetch```
- Cross validate if the connection is established by using below command.
    ```knife ssl check```
    > It should show "successfully connected to api.chef.io"

## Bootstrap a node
Bootstrap a node will install chef client on the specific node. We can do bootstrap a node from workstation by using below command.
-  bootstrap <hostname/ip> -N <Name to Display on Server> -U vagrant --sudo
    ```
    knife bootstrap lb1 -N lb1 -U vagrant --sudo -y
    ```
    ```
    knife bootstrap web1 -N web1 -U vagrant --sudo -y
    ```
    ```
    knife bootstrap web2 -N web2 -U vagrant --sudo -y
    ```
    
## Generate Cookbook and upload it to Chef Server
As our goal is to install Load Balancer and Apache Web Application we need to write recipe.

- To generate a cookbook we can use following command:
    ```
    chef generate cookbook cookbooks/install-lb-haproxy
    ```
    ```
    chef generate cookbook cookbooks/install-app-apache2
    ```
-  to upload it we can use
    ```
    knife upload cookbooks/<cookbook name>
    ```

## Add recipe to a  node as runlist and execution from node
We need to add a specific recipe(s) to a node to process the task. By using following command we can add the recipe to the run list.
    ```
    knife node run_list add lb1 recipe[install-lb-haproxy]
    ```
- Upon succesfull addition of recipe as run list for a node we can login to the nodes and installation can be process autmaticly by using below command.
    ```
    sudo chef-client
    ```
- It will identify the recipe and do the needfull accordingly.

## Execute the recipe on multiple nodes using Role based approach.


# Challenges
    
- Issue-1 - "ERROR: Train::ClientError: Your SSH Agent has no keys added, and you have not specified a password or a key file"
    -   Solution : 
        ```shell
        eval `ssh-agent`
        ssh-add
        ```
- Issue-2 - SSL Error on Ubuntu Server.
    -   Solution :
        ```shell
        sudo cp sslcerts.crt /usr/local/share/ca-certificates
        sudo update-ca-certificates --fresh
        ```
- Issue-3 -  SSH Error while Bootstraping a node
    -   Solution : 
        Make sure the public key of workstation updated on authorized_key file of the node. As we are doing the bootstraping from workstation, ssh connectivity should be in place.
    
