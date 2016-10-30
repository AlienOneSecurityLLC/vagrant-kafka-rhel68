# -*- mode: ruby -*-
# vi: set ft=ruby :

# Global
Vagrant.configure("2") do |config|

  config.vm.box = "puppetlabs/centos-6.6-64-puppet"
  config.ssh.forward_agent = true
  config.ssh.insert_key = false 
  config.vm.provision "shell", path: "scripts/init.sh", privileged: true

  # Instance
  (1..3).each do |i|
    config.vm.define "zkafka#{i}" do |s|
      s.vm.hostname = "zkafka#{i}"
      s.vm.network "private_network", ip: "10.30.3.#{i+1}", netmask: "255.255.255.0", virtualbox__intnet: "my-network", drop_nat_interface_default_route: true
      s.vm.network "forwarded_port", guest: 2181, host: 2181
      s.vm.network "forwarded_port", guest: 9092, host: 9092
    end
  end

# Global
  config.vm.provider "virtualbox" do |v|
    v.customize ["modifyvm", :id, "--cpuexecutioncap", "50"]
  end
end

