#!/usr/bin/env bash

#title           :logstash.sh
#description     :Vagrant shell script to setup ArcSight Smart Connector Host
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

########################################################
# Get ArcSight Linux Smart Connector Installation Binary
########################################################
echo "Getting software..."
wget -O "/opt/ArcSight-7.3.0.7886.0-Connector-Linux64.bin" https://www.dropbox.com/s/zzrumm0q08x20aj/ArcSight-7.3.0.7886.0-Connector-Linux64%20%281%29.bin?dl=0

#######################
# CENTOS 6.8 UPDATE
#######################
echo "Updating CentOS 6.6 to CentOS 6.8"
rpm --import https://yum.puppetlabs.com/RPM-GPG-KEY-puppet
yum clean all
yum -y update
echo "Completed upgrading CentOS 6.6 to CentOS 6.8"
