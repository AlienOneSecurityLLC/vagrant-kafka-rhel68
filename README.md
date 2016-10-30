![](https://github.com/AlienOneSecurityLLC/vagrant-kafka/blob/master/images/Kafka-Zookeeper-Pub-Sub.png)

###Vagrant Kafka/Zookeeper 
=============
####Vagrant Configuration
    + Provisions **six** CentOS 6.8 VMs
    + Three node Apache Zookeeper Quorum (Replicated ZooKeeper)
    + Three Apache Kafka Brokers 
    + JDK 8u112
    + Kafka 0.10.1.0 
    + Scala 2.10 
    + Zookeeper 3.4.9 

#####Prerequisites - Install the following prerequisites 
-------------------------
+ [Vagrant](https://www.vagrantup.com/downloads.html)
+ [VirtualBox](https://www.virtualbox.org/wiki/Downloads)

####Setup
-------------------------
```
git clone https://github.com/AlienOneSecurityLLC/vagrant-kafka.git
cd vagrant-kafka 
vagrant up
```
####Node Setup 
--------------------------
```
rpm -qal kafka | less
rpm -qal zookeeper | less
```

####VM Mappings & IP Addresses:
--------------------------

| Name        | Address|
|-------------|-----------|
|zookeeper1   | 10.30.3.2 |
|zookeeper2   | 10.30.3.3 |
|zookeeper3   | 10.30.3.4 |
|broker1      | 10.30.3.30|
|broker2      | 10.30.3.20|
|broker3      | 10.30.3.10|


####Unit Status Test 
-------------------------

+ Test all VM nodes are in state RUNNING 

```
vagrant status
```

```
Current machine states:

zkafka1                running (virtualbox)
zkafka2                running (virtualbox)
zkafka3                running (virtualbox)


This environment represents multiple VMs. The VMs are all listed
above with their current state. For more information about a specific
VM, run 'vagrant status NAME''.
```
