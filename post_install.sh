#!/bin/bash

[[ `which inetsim` ]] || sudo apt install -y inetsim
sudo service inetsim start
sudo service postgresql start
