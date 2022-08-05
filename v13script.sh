#!/bin/bash

#To delete frappe_bench folder if already installed to avoid error
rm -rf frappe-bench

#Download anaconda form anaconda.com    Note: update link if newer version available
sudo apt-get update; sudo apt-get install make build-essential libssl-dev zlib1g-dev \
libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

#virtual environment name can be anything without space and special character to use later commands like "conda activate myenv"
echo "Enter name for virtual environment(without spaces) :"
read VARNAME
sleep 2

#Anaconda script will run to install anaconda.       TIP: Do "ctrl+c" and then "v" to skip agreement details if you don't want to read that
chmod 755 Anaconda3-2022.05-Linux-x86_64.sh
./Anaconda3-2022.05-Linux-x86_64.sh
sleep 2

#To activate (base) environment and use "conda" command
source /home/$(whoami)/anaconda3/bin/activate

#It will install right version of python in env which is 3.8.1
conda create -n $VARNAME python=3.8.1
sleep 2

#To activate your environment with python=3.8.1
conda activate $VARNAME

#To check if version is right
python --version
sleep 5

#It will install bench=5.8.1
pip3 install frappe-bench==5.8.1

#It will install frappe v13 in "frappe_bench" folder
bench init --frappe-branch v13.23.0 frappe-bench
cd frappe-bench

#New site where erpnext v13 will be installed
echo "Enter Domain name  (must not be registerd in mysql before)  :"
read SITENAME

#It will install erpnext v13 app in "frappe_bench" folder
bench get-app erpnext --branch v13.23.0

#Site is installing
bench new-site $SITENAME
bench use $SITENAME

#Erp will install in site
bench --site $SITENAME install-app erpnext

echo "Thanks for using script. Now use "bench start"   -Envy"
