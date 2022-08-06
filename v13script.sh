#!/bin/bash

#To delete frappe_bench folder if already installed to avoid error

#setting up utilities
sudo apt clean
sudo apt upgrade -y 
sudo apt clean 
sudo apt-get update -y
sudo apt clean
sleep 3
sudo apt-get install git make build-essential libssl-dev zlib1g-dev -y
sudo apt install libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm -y
sudo apt install libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev redis mariadb-server cron -y
sudo apt install supervisor -y
curl -fsSL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt-get install -y nodejs
sudo apt update -y
sudo apt install npm -y
sudo systemctl start mariadb
sudo systemctl start redis
sudo systemctl start supervisor
echo " Do you want to change password of mysql? (yes/no)"
read OPTION 

if [ $OPTION = yes ] || [ $OPTION = y ];
then
    sudo mysql_secure_installation
fi
sudo npm install --global yarn

git clone https://github.com/pyenv/pyenv.git ~/.pyenv

echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(pyenv init -)"' >> ~/.bashrc

. ~/.bashrc
pyenv install 3.8.1 
cd
pyenv shell 3.8.1

python --version

pip3 install frappe-bench==5.8.1
rm -rf frappe_v13

bench init --frappe-branch v13.23.0 frappe_v13
cd frappe_v13

pyenv local 3.8.1
bench get-app erpnext --branch v13.23.0
echo "Enter Domain name  (must not be registerd in mysql before)  :"
read SITENAME
bench new-site $SITENAME
bench use $SITENAME
bench --site $SITENAME install-app erpnext
echo "Thanks for using script. Now use "bench start"   -Envy"
