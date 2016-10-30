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
git clone git@github.com:AlienOneSecurityLLC/vagrant-kafka.git
cd vagrant-kafka 
vagrant up
```

####Node Setup
-------------------------
+ $KAFKA_HOME_DIR ```$HOME/kafka_2.11-0.10.1.0/```
+ $ZOOKEEPER_HOME_DIR ```embedded version of Zookeeper bundled with Kafka utilized```

####VM Mappings & IP Addresses:
--------------------------

| Name        | Address    |
|-------------|------------|
|zookeeper1   | 10.30.3.2  |
|zookeeper2   | 10.30.3.3  |
|zookeeper3   | 10.30.3.4  |
|broker1      | 10.30.3.30 |
|broker2      | 10.30.3.20 |
|broker3      | 10.30.3.10 |


####Unit Status Test 
-------------------------

+ Test all VM nodes are in state RUNNING 

```
vagrant status
```

```
Current machine states:

zookeeper1                running (virtualbox)
zookeeper2                running (virtualbox)
zookeeper3                running (virtualbox)
broker1                   running (virtualbox)
broker2                   running (virtualbox)
broker3                   running (virtualbox)


This environment represents multiple VMs. The VMs are all listed
above with their current state. For more information about a specific
VM, run 'vagrant status NAME''.
```

####Unit Accesses Test 
----------------------

+ Login to any host with e.g., ```vagrant ssh broker1```. Some scripts have been included for convenience:

+ Create a new topic ```/vagrant/scripts/create_topic.sh <topic name>``` (create as many as you see fit)

+ Topic details can be listed with ```/vagrant/scripts/list-topics.sh```

+ Start a console producer ```/vagrant/scripts/producer.sh <opic name>```. Type few messages and seperate them with new lines (Ctl-C to exit). 

+ ```/vagrant/scripts/consumer.sh <topic name>```: this will create a console consumer, getting messages from the topic created before. It will read all the messages each time starting from the beginning.

+ Now anything you type in producer, it will show on the consumer. 

####Startup of all VMs
------

```for i in zookeeper{1..3} broker{1..3};do vagrant up $i;done```

####Graceful Stop of All VMs 
------

```for i in zookeeper{1..3} broker{1..3};do vagrant halt $i;done;```

####Teardown & Rebase Development & Test Environment 
------

+ To destroy/delete all the VMs

```for i in zookeeper{1..3} broker{1..3};do vagrant destroy $i;done;```


####Insights
-------------

#####Zookeeper (ZK)

+ Kafka is using ZK for its operation. Here are some commands you can run on any of the nodes to see some of the internal Zookeeper structures created by Kafka. 

+ Open a ZK shell:

```$HOME/kafka_2.11-0.10.1.0/bin/zookeeper-shell.sh 10.30.3.2:2181/```

+ Inspect ZK structure: 

```
ls /
[controller, controller_epoch, brokers, zookeeper, admin, isr_change_notification, consumers, config]
```

+ Get ZK version:
    + First we need to install **nc** ```sudo yum install nc -y```
    + To get the version of ZK type:
    
     ```
     echo status | nc 10.30.3.2 2181
     ```

    + You can replace 10.30.3.2 with any ZK IP and execute the above command from any node within the cluster. 


#####Kafka

+ Here we will see some more ways we can ingest data into Kafa. 

+ Pipe data directly into Kafka

+ Login to any of the 6 nodes

```
vagrant ssh zookeeper1
```

+ Create a topic if does not exist

```
 /vagrant/scripts/create_topic.sh test-one
```

+ Send data to the Kafka topic

```
echo "Yet another line from stdin" | ./kafka_2.11-0.10.1.0/bin/kafka-console-producer.sh --topic test-one --broker-list 10.30.3.10:9092,10.30.3.20:9092,10.30.3.30:9092
```

+ You can then test that the line was added by running the consumer

```
/vagrant/scripts/consumer.sh test-one
```

+ Add a continues stream of data into Kafka

+ Running **vmstat** will periodically export stats about the VM you are attached to. 

```
>vmstat -a 1

procs -----------memory---------- ---swap-- -----io---- --system-- -----cpu-----
 r  b   swpd   free  inact active   si   so    bi    bo   in   cs us sy id wa st
 0  0    960 113312 207368 130500    0    0    82   197  130  176  0  1 99  0  0
 0  0    960 113312 207368 130500    0    0     0     0   60   76  0  0 100  0  0
 0  0    960 113304 207368 130540    0    0     0     0   58   81  0  0 100  0  0
 0  0    960 113304 207368 130540    0    0     0     0   53   76  0  1 99  0  0
 0  0    960 113304 207368 130540    0    0     0     0   53   78  0  0 100  0  0
 0  0    960 113304 207368 130540    0    0     0    16   64   90  0  0 100  0  0
```

+ We can redirect this output into Kafka

```
vmstat -a 1 | ./kafka_2.11-0.10.1.0/bin/kafka-console-producer.sh --topic test-one --broker-list 10.30.3.10:9092,10.30.3.20:9092,10.30.3.30:9092 &
```

+ While the producer runs in the background you can start the consumer to see what happens

```
/vagrant/scripts/consumer.sh test-one
```

+ You should be seeing the output of **vmstat** in the console. 

+ When you are all done, kill the consumer by **ctl-C** and then type **fg** to bring the producer in foreground and **crl-C** to terminate it. 


