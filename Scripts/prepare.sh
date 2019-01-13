#!/bin/bash -e
echo "***** Install Epel-7 Repo"
wget http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo rpm -ivh epel-release-latest-7.noarch.rpm
sudo yum clean all
sudo yum update --disablerepo=epel -y
echo "***** Create Jmeter Directory ****"
sudo mkdir /opt/jmeter
echo "***** Install Ansible and Pip  Repo"
sudo yum  install ansible  python-setuptools python-pip  -y
echo "***** Starting Docker and Docker Compose Installation configuration"
sudo amazon-linux-extras install docker -y

