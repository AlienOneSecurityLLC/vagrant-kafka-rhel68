<img src="https://github.com/AlienOneSecurityLLC/vagrant-kafka/blob/master/images/Kafka-Zookeeper-Pub-Sub.png" alt="hi" class="inline"/>

##Dev/Test Data Pipeline
=========================

###Vagrant Kafka/Zookeeper 
=============
####Vagrant Configuration: 5 VMs Total 
    + CentOS 6.8 VMs
    + Three Apache Zookeeper Quorum (Replicated ZooKeeper)
    + Three Apache Kafka Brokers 
    + JDK 8u112
    + Kafka 0.10.1.0 
    + Scala 2.10 
    + Zookeeper 3.4.9 
    + One Logstash 4.0 Node 
    + One ArcSight Smart Connector 7.3.0.7886.0 Node 

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

| Name        | Address   | 
|-------------|-----------|
|zkafka1      | 10.30.3.2 | 
|zkafka2      | 10.30.3.3 |
|zkafka3      | 10.30.3.4 |
|logstash1    | 10.30.3.5 |
|connector1   | 10.30.3.6 |


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
logstash1              running (virtualbox)
connector1             running (virtualbox)


This environment represents multiple VMs. The VMs are all listed
above with their current state. For more information about a specific
VM, run 'vagrant status NAME''.
```
####Apache Kafka Quick Start 
---------------------------
[Apache Kafka Quick Start](https://kafka.apache.org/documentation#quickstart_createtopic)
