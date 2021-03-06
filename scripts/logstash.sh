#!/usr/bin/env bash

#title           :logstash.sh
#description     :Vagrant shell script to install logstash 5.0
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

echo "installing jdk and kafka ..."

rpm -ivh /tmp/$JDK_RPM

#######################
# INSTALL LOGSTASH 5.0
#######################
echo "Installing logstash"
rpm --import https://packages.elastic.co/GPG-KEY-elasticsearch
cp /vagrant/config/logstash.repo /etc/yum.repos.d
mkdir -p /opt/logstash
cp /vagrant/config/logstash.conf /etc/logstash/conf.d
echo "Installation logstash completed"
echo "Installing logstash plugins - logstash-input-kafka, logstash-output-syslog, logstash-codec-cef, and logstash-codec-avro"
/opt/logstash/bin/./logstash-plugin install logstash-input-kafka
/opt/logstash/bin/./logstash-plugin install logstash-output-syslog
/opt/logstash/bin/./logstash-plugin install logstash-codec-cef
/opt/logstash/bin/./logstash-plugin install logstash-codec-avro
/opt/logstash/bin/./logstash-plugin update all 
echo "Logstash plugins installation completed"
chown -R logstash:logstash /opt/logstash
/sbin/chkconfig logstash on
/sbin/service logstash start
#######################
# CENTOS 6.8 UPDATE
#######################
echo "Updating CentOS 6.6 to CentOS 6.8"
rpm --import https://yum.puppetlabs.com/RPM-GPG-KEY-puppet
yum clean all
yum -y update
echo "Completed upgrading CentOS 6.6 to CentOS 6.8"
