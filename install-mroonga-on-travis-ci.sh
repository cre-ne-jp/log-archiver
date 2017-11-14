#!/bin/bash

# Enable the universe repository and the security update repository to install Mroonga
sudo apt install -y -V software-properties-common lsb-release
sudo add-apt-repository -y universe
sudo add-apt-repository "deb http://security.ubuntu.com/ubuntu $(lsb_release --short --codename)-security main restricted"

# Add the ppa:groonga/ppa PPA to the system
sudo add-apt-repository -y ppa:groonga/ppa
sudo apt update

# Install Mroonga for MySQL
sudo apt install -y -V mysql-server-mroonga
