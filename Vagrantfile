# -*- mode: ruby -*-
# vi: set ft=ruby :

# Global
Vagrant.configure("2") do |config|

  config.vm.box = "puppetlabs/centos-6.6-64-puppet"
  config.ssh.forward_agent = true
  config.ssh.insert_key = false

  # Zookeeper & Kafka Instances => 3 Instances Spawned
  (1..3).each do |i|
    config.vm.define "zkafka#{i}" do |s|
      s.vm.hostname = "zkafka#{i}"
      s.vm.network "private_network", ip: "10.30.3.#{i+1}", netmask: "255.255.255.0", virtualbox__intnet: "my-network", drop_nat_interface_default_route: true
      s.vm.provision "shell", path: "scripts/zkafka.sh", args:"#{i}", privileged: true
    end
  end

  # Logstash Instance => 1 Instance Spawned
  (1..1).each do |i|
    config.vm.define "logstash1" do |s|
      s.vm.define "logstash1"
      s.vm.hostname = "logstash1"
      s.vm.network "private_network", ip: "10.30.3.5", netmask: "255.255.255.0", virtualbox__intnet: "my-network", drop_nat_interface_default_route: true
      s.vm.provision "shell", path: "scripts/logstash.sh", privileged: true
    end
  end
  
  # Connector Instance => 1 Instance Spawned
  (1..1).each do |i|
    config.vm.define "logstash1" do |s|
      s.vm.define "connector1"
      s.vm.hostname = "connector1"
      s.vm.network "private_network", ip: "10.30.3.6", netmask: "255.255.255.0", virtualbox__intnet: "my-network", drop_nat_interface_default_route: true
      s.vm.provision "shell", path: "scripts/connector.sh", privileged: true
    end
  end

# Global
  config.vm.provider "virtualbox" do |v|
    v.customize ["modifyvm", :id, "--cpuexecutioncap", "50"]
  end
end
