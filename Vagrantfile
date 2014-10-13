# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.define :hanlon do |hanlon_cfg|
    hanlon_cfg.vm.box = "puppetlabs/debian73-i386"
    hanlon_cfg.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/debian-73-i386-virtualbox-puppet.box"
    hanlon_cfg.vm.hostname = "hanlon-server"
    # Create a private, internal-only network
    hanlon_cfg.vm.network "private_network", ip: "192.168.66.254", virtualbox__intnet: "hanlon-net"

    hanlon_cfg.vm.provider "virtualbox" do |vb|
      vb.name = "Hanlon Sandbox"
      vb.cpus = 1
      vb.memory = 1024
    end

    hanlon_cfg.vm.provision :shell, :inline => 'apt-get update && apt-get -y install apt-transport-https'
    hanlon_cfg.vm.provision "puppet" do |puppet|
      puppet.manifests_path = "provision/manifests"
      puppet.module_path = "provision/modules"
      puppet.manifest_file  = "default.pp"
    end
  end

  config.vm.define :agent do |agent_cfg|
    agent_cfg.vm.box = 'agent1'
    agent_cfg.vm.box_url = 'https://github.com/downloads/benburkert/bootstrap-razor/pxe-blank.box'
    agent_cfg.vm.network "private_network", adapter: 1, type: "dhcp", virtualbox__intnet: "hanlon-net"

    agent_cfg.vm.network :forwarded_port, guest: 22, host: 2220, disabled: true, id: "ssh"

    agent_cfg.vm.provider "virtualbox" do |vb|
      vb.name = "Agent"
      vb.gui = true
    end
  end
end

