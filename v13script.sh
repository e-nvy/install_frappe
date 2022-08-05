#!/bin/bash

#To delete frappe_bench folder if already installed to avoid error
# rm -rf frappe-bench


#setting up utilities
sudo apt clean
sudo apt upgrade -y 
sudo apt clean 
sudo apt-get update -y
sudo apt clean

sudo apt-get install make build-essential libssl-dev zlib1g-dev \
libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev redis mariadb cron -y
curl -fsSL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt-get install -y nodejs yarn
sudo systemctl start mariadb
sudo systemctl start redis
sudo mysql_secure_installation

git clone https://github.com/pyenv/pyenv.git ~/.pyenv

cd ~/.pyenv && src/configure && make -C src

echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(pyenv init -)"' >> ~/.bashrc

. ~/.bashrc
#exec "$SHELL"
echo "Done till now"
python -V
. ~/.bashrc
pyenv install 3.8.1 
cd
pyenv shell 3.8.1
#To check if version is right
python --version
sleep 5
# #It will install bench=5.8.1
pip3 install frappe-bench==5.8.1

# #It will install frappe v13 in "frappe_bench" folder
bench init --frappe-branch v13.23.0 frappe_v13
cd frappe-bench_v13

pyenv local 3.8.1

# #It will install erpnext v13 app in "frappe_bench" folder
bench get-app erpnext --branch v13.23.0

bench new-site $SITENAME
bench use $SITENAME
echo "Enter Domain name  (must not be registerd in mysql before)  :"
read SITENAME

# #Erp will install in site
bench --site $SITENAME install-app erpnext

echo "Thanks for using script. Now use "bench start"   -Envy"
