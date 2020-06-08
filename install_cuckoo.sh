#!/bin/bash

cd $HOME
sudo apt update -y

# Prerequisites
sudo apt install -y python python-pip python-dev libffi-dev libssl-dev python-virtualenv python-setuptools libjpeg-dev zlib1g-dev swig mongodb postgresql libpq-dev swig

# Extras
sudo apt install -y python-pip

# VirtualBox instalation
sudo apt install -y virtualbox virtualbox-ext-pack virtualbox-guest-additions-iso virtualbox-dkms

# tcpdump
sudo apt install -y tcpdump apparmor-utils
sudo aa-disable /usr/sbin/tcpdump
sudo setcap cap_net_raw,cap_net_admin=eip /usr/sbin/tcpdump

# pip
pip install virtualenv
python2 -m virtualenv cuckoo_env
source cuckoo_env/bin/activate

# volatility
mkdir .tmp && cd .tmp
wget https://github.com/volatilityfoundation/volatility/archive/2.5.tar.gz
tar -xzvf 2.5.tar.gz
cd volatility-2.5
python setup.py install

cd ..

# yara
wget https://github.com/plusvic/yara/archive/v3.4.0.tar.gz
tar -xzvf v3.4.0.tar.gz
cd yara-3.4.0/
sudo apt-get install automake libtool make gcc libssl-dev libjansson-dev libmagic-dev
./bootstrap.sh
./configure --with-crypto --enable-cuckoo --enable-magic
make
sudo make install
cd ..

# DEPENDENCY OF pydeep: libssdeep
wget https://github.com/ssdeep-project/ssdeep/archive/release-2.14.1.tar.gz
tar -xzvf release-2.14.1.tar.gz
cd ssdeep-release-2.14.1/
./bootstrap
./configure
make
sudo make install
cd ..

# pydeep
wget https://github.com/kbandla/pydeep/archive/0.2.tar.gz
tar -xzvf 0.2.tar.gz
cd pydeep-0.2/
python setup.py install
cd ..

cd ..
rm -rf .tmp

# mitmproxy
pip install mitmproxy

# m2crypto
pip install m2crypto==0.24.0

# guacd
sudo apt install -y libguac-client-rdp0 libguac-client-vnc0 libguac-client-ssh0 guacd

# ================================================== #

# user
sudo usermod -a -G vboxusers cuckoo

sudo su -c 'cat >> /etc/security/limits.conf << EOF
*         hard    nofile      500000
*         soft    nofile      500000
root      hard    nofile      500000
root      soft    nofile      500000
EOF'

sudo su -c 'echo "session required pam_limits.so" >> /etc/pam.d/common-session'
sudo su -c 'echo "fs.file-max = 2097152" >> /etc/sysctl.conf '
sudo sysctl -p

# cuckoo installation
pip install -U pip setuptools distorm3==3.4.4
pip install -U cuckoo

