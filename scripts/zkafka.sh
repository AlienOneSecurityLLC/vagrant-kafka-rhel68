#!/usr/bin/env bash


#title           :logstash.sh
#description     :Vagrant shell script install Zookeeper & Kafka
#author		     :Justin Jessup
#date            :10/30/2016
#version         :0.1
#usage		     :bash logstash.sh
#notes           :Executed via Vagrant => vagrant-kafka
#bash_version    :GNU bash, version 4.1.2(1)-release (x86_64-redhat-linux-gnu)
#License         :MIT
#==============================================================================


###########################
# ORACLE JAVA JDK 8 INSTALL
###########################
echo "Installing Oracle Java Development Kit"
JDK_VERSION="jdk-8u112-linux-x64"
JDK_RPM="$JDK_VERSION.rpm"

if [ ! -f /tmp/$JDK_RPM ]; then
    echo Downloading $JDK_RPM
    wget –quiet -O /tmp/$JDK_RPM --no-check-certificate --no-cookies --header \
    "Cookie: oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u112-b15/$JDK_RPM"
fi

echo "Disabling iptables"
/etc/init.d/iptables stop
/sbin/chkconfig iptables off

echo "Installing JDK Version: $JDK_VERSION"
rpm -ivh /tmp/$JDK_RPM
echo "Completed installation JDK Version: $JDK_VERSION"

########################
# ZOOKEEPER INSTALL
########################
echo "Installing Zookeeper"
yum -y install git lsof
cd /opt
git clone https://github.com/AlienOneSecurityLLC/zookeeper-rpm.git
cd /opt/zookeeper-rpm
yum -y install make rpmdevtools
make rpm
cd /opt/zookeeper-rpm/x86_64
rpm -ivh zookeeper*.rpm
chkconfig zookeeper on
cd /opt/zookeeper/data
echo "Setting unique zookeeper id..."
touch myid
str=$(hostname)
last_char="${str: -1}"
cd /opt/zookeeper/data
echo $last_char > myid
echo 'JVMFLAGS="-Xmx2048m -Djute.maxbuffer=1000000000"' >> /etc/sysconfig/zookeeper
echo "server.1=10.30.3.2:2888:3888" >> /etc/zookeeper/zoo.cfg
echo "server.2=10.30.3.3:2888:3888" >> /etc/zookeeper/zoo.cfg
echo "server.3=10.30.3.4:2888:3888" >> /etc/zookeeper/zoo.cfg
chown -R zookeeper:zookeeper /opt/zookeeper
service zookeeper start
sed -i 's/eforward        2181\/tcp                \# eforward/zookeeper        2181\/tcp                \# zookeeper/g' /etc/services
lsof -i TCP:2181 | grep LISTEN
echo "Completed installation of Zookeeper"

#######################
# INSTALL KAFKA
#######################
cd /opt
git clone https://github.com/AlienOneSecurityLLC/kafka-rpm.git
cd /opt/kafka-rpm
make rpm
cd /opt/kafka-rpm/x86_64
rpm -ivh kafka*.rpm
echo "Setting unique kafka broker id..."
str=$(hostname)
last_char="${str: -1}"
sed -i "s/broker.id\=0/broker.id\=$last_char/g" /opt/kafka/config/server.properties
ip_address=$(ifconfig -a eth1 | grep 'inet addr\:' | cut -d':' -f2 | awk '{print $1}')
sed -i "s/\#advertised.listeners\=PLAINTEXT\:\/\/your.host.name:9092/advertised.listeners\=PLAINTEXT\:\/\/$ip_address:9092/g" /opt/kafka/config/server.properties
mkdir -p /opt/kafka-logs-1
sed -i "s/log.dirs\=\/tmp\/kafka-logs/log.dirs\=\/opt\/kafka-logs-1/g" /opt/kafka/config/server.properties
sed -i "s/num.partitions\=1/num.partitions\=3/g" /opt/kafka/config/server.properties
sed -i "s/\#delete.topic.enable\=true/delete.topic.enable\=true/g" /opt/kafka/config/server.properties
sed -i "s/zookeeper.connect\=localhost\:2181/zookeeper.connect\=localhost\:2181,10.30.3.2\:2181,10.30.3.3\:2181,10.30.3.4\:2181/g" /opt/kafka/config/server.properties
chkconfig kafka on
chown -R kafka:kafka /opt/kafka-logs-1
chown -R kafka:kafka /opt/kafka
service kafka start
sed -i "s/XmlIpcRegSvc    9092\/tcp                \# Xml-Ipc Server Reg/kafka    9092\/tcp                \# Kafka/g" /etc/services
lsof -i TCP:9092 | grep LISTEN
echo "Completed installation of Kafka"


#######################
# CENTOS 6.8 UPDATE
#######################
echo "Updating CentOS 6.6 to CentOS 6.8"
rpm --import https://yum.puppetlabs.com/RPM-GPG-KEY-puppet
yum clean all
yum -y update
echo "Completed upgrading CentOS 6.6 to CentOS 6.8"
