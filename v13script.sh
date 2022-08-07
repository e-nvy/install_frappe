#!/bin/bash


sudo apt clean 
sudo apt-get update -y

sudo apt upgrade -y 
sudo apt install aptitude -y

########################################
######### Dependencies #################
########################################

sudo aptitude install git make build-essential libssl-dev figlet zlib1g-dev -y
sudo aptitude install libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm -y
sudo aptitude install libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev redis mariadb-server cron -y
sudo aptitude install supervisor -y
curl -fsSL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo aptitude install -y nodejs
sudo aptitude update -y
sudo aptitude install npm -y

########################################

# Setting up mysql and other services ##

sudo mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
sudo systemctl start mariadb
sudo systemctl start redis
sudo systemctl start supervisor
echo " Do you want to change password of mysql? (yes/no)"
read OPTION 

if [ $OPTION = yes ] || [ $OPTION = y ];
then
    sudo mysql_secure_installation
fi

sudo cat /dev/null > /etc/mysql/mariadb.conf.d/50-server.cnf
sudo echo "# These groups are read by MariaDB server.
# Use it for options that only the server (but not clients) should see

# this is read by the standalone daemon and embedded servers
[server]

user = mysql
pid-file = /run/mysqld/mysqld.pid
socket = /run/mysqld/mysqld.sock
basedir = /usr
datadir = /var/lib/mysql
tmpdir = /tmp
lc-messages-dir = /usr/share/mysql
bind-address = 127.0.0.1
query_cache_size = 16M
log_error = /var/log/mysql/error.log

# this is only for the mysqld standalone daemon
[mysqld]

innodb-file-format=barracuda
innodb-file-per-table=1
innodb-large-prefix=1
character-set-client-handshake = FALSE
character-set-server = utf8mb4
collation-server = utf8mb4_unicode_ci

#
# * Basic Settings
#

#user                    = mysql
pid-file                = /run/mysqld/mysqld.pid
basedir                 = /usr
#datadir                 = /var/lib/mysql
#tmpdir                  = /tmp

# Broken reverse DNS slows down connections considerably and name resolve is
# safe to skip if there are no "host by domain name" access grants
#skip-name-resolve

# Instead of skip-networking the default is now to listen only on
# localhost which is more compatible and is not less secure.
bind-address            = 127.0.0.1

#
# * Fine Tuning
#

#key_buffer_size        = 128M
#max_allowed_packet     = 1G
#thread_stack           = 192K
#thread_cache_size      = 8
# This replaces the startup script and checks MyISAM tables if needed
# the first time they are touched
#myisam_recover_options = BACKUP
#max_connections        = 100
#table_cache            = 64

#
# * Logging and Replication
#

# Both location gets rotated by the cronjob.
# Be aware that this log type is a performance killer.
# Recommend only changing this at runtime for short testing periods if needed!
#general_log_file       = /var/log/mysql/mysql.log
#general_log            = 1

# When running under systemd, error logging goes via stdout/stderr to journald
# and when running legacy init error logging goes to syslog due to
# /etc/mysql/conf.d/mariadb.conf.d/50-mysqld_safe.cnf
# Enable this if you want to have error logging into a separate file
#log_error = /var/log/mysql/error.log
# Enable the slow query log to see queries with especially long duration
#slow_query_log_file    = /var/log/mysql/mariadb-slow.log
#long_query_time        = 10
#log_slow_verbosity     = query_plan,explain
#log-queries-not-using-indexes
#min_examined_row_limit = 1000

# The following can be used as easy to replay backup logs or for replication.
# note: if you are setting up a replication slave, see README.Debian about
#       other settings you may need to change.
#server-id              = 1
#log_bin                = /var/log/mysql/mysql-bin.log
expire_logs_days        = 10
#max_binlog_size        = 100M

#
# * SSL/TLS
#

# For documentation, please read
# https://mariadb.com/kb/en/securing-connections-for-client-and-server/
#ssl-ca = /etc/mysql/cacert.pem
#ssl-cert = /etc/mysql/server-cert.pem
#ssl-key = /etc/mysql/server-key.pem
#require-secure-transport = on

#
# * Character sets
#

# MySQL/MariaDB default is Latin1, but in Debian we rather default to the full
# utf8 4-byte character set. See also client.cnf
#character-set-server  = utf8mb4
#collation-server      = utf8mb4_general_ci

#
# * InnoDB
#

# InnoDB is enabled by default with a 10MB datafile in /var/lib/mysql/.
# Read the manual for more InnoDB related options. There are many!
# Most important is to give InnoDB 80 % of the system RAM for buffer use:
# https://mariadb.com/kb/en/innodb-system-variables/#innodb_buffer_pool_size
#innodb_buffer_pool_size = 8G

# this is only for embedded server
[embedded]

# This group is only read by MariaDB servers, not by MySQL.
# If you use the same .cnf file for MySQL and MariaDB,
# you can put MariaDB-only options here
[mariadb]

# This group is only read by MariaDB-10.6 servers.
# If you use the same .cnf file for MariaDB of different versions,
# use this group for options that older servers don't understand
[mariadb-10.6]

[mysql]
default-character-set = utf8mb4" >> /etc/mysql/mariadb.conf.d/50-server.cnf

sudo systemctl restart mariadb

##########################################

sudo npm install --global yarn

####### Installing Pyenv #################
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

echo 'Enter site name(must not included in mysql database) :'
read SITENAME
bench new-site $SITENAME
bench use $SITENAME

bench --site $SITENAME install-app erpnext


echo "Thanks for using script. Now use "bench start""
echo "- Envy" | figlet -f slant