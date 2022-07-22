#!/bin/bash

sudo apt-get update >> /var/log/update_script.log
sudo apt-get upgrade -y >> /var/log/update_script.log
