# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "puppetlabs/debian73-i386"
  config.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/debian-73-i386-virtualbox-puppet.box"
  config.vm.hostname = "hanlon-server"
  # Create a private, internal-only network
  config.vm.network "private_network", ip: "192.168.66.254", virtualbox__intnet: "hanlon-net"

  config.vm.provider "virtualbox" do |vb|
    vb.name = "Hanlon Sandbox"
    vb.cpus = 1
    vb.memory = 1024
  end

  config.vm.provision :shell, :inline => 'apt-get update && apt-get -y install apt-transport-https'
  config.vm.provision "puppet" do |puppet|
    puppet.manifests_path = "provision/manifests"
    puppet.module_path = "provision/modules"
    puppet.manifest_file  = "default.pp"
  end
end

