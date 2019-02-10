#!/usr/bin/env bash

timezone=$(echo "$1")

function info {
  echo " "
  echo "-> $1"
  echo " "
}

#== Provision script ==
info "Provision-script user: `whoami`"
info "Configure timezone"
timedatectl set-timezone ${timezone} --no-ask-password
export DEBIAN_FRONTEND=noninteractive

info "Update OS software"
apt-get update
apt-get upgrade -y

info "Install additional software"
apt-get install -y unzip nginx curl git autoconf automake libtool pkg-config

info "Create 8G Swapfile"
fallocate -l 8G /swapfile && chmod 0600 /swapfile && mkswap /swapfile && swapon /swapfile && echo '/swapfile none swap sw 0 0' >> /etc/fstab
echo vm.swappiness = 10 >> /etc/sysctl.conf && echo vm.vfs_cache_pressure = 50 >> /etc/sysctl.conf && sysctl -p

info "Configure NGINX"
sed -i 's/user www-data/user vagrant/g' /etc/nginx/nginx.conf
echo "Done!"

info "Enabling site configuration"
ln -s /app/vagrant/config/nginx/app.conf /etc/nginx/sites-enabled/app.conf
echo "Done!"

info "Removing default site configuration"
rm /etc/nginx/sites-enabled/default
echo "Done!"

info "Install NodeJS" # and Yarn"
curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
apt-get update
apt-get install -y nodejs

info "Install Java 8 for ElasticSearch 5"
add-apt-repository ppa:webupd8team/java
apt install -y oracle-java8-set-default

wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.6.14.deb
dpkg -i elasticsearch-5.6.14.deb

#@todo this not work yet, address to 127.0.0.1 in cofig
sed -i 's/#network.host:/network.host: 127.0.0.1' /etc/elasticsearch/elasticsearch.yml

systemctl enable elasticsearch.service
systemctl start elasticsearch.service
# additional plugin
sudo /usr/share/elasticsearch/bin/elasticsearch-plugin install analysis-icu
# check under http://pelias.devel:9200/_cat/health?v
systemctl restart elasticsearch.service

# @todo: Install LibPostal, and Enable IT in pelias
# info "Install LibPostal"

#git clone https://github.com/openvenues/libpostal
#cd libpostal
#./bootstrap.sh
#./configure --datadir=/home/vagrant/libpostal-data
#make -j4
#sudo make install
#sudo ldconfig

# @todo - remebmer to install in properly custom directories
# @todo - remember to pelias.json in custom location ex /etc/pelias.json not in ~
# @todo - whosonfirst installation
# @todo -
# @todo - geonames installation

# 1. First is There a works under schema https://github.com/pelias/schema
# BUG: command npm run create_index - can work, but there are problem with POST / PUT.
# program want POST, but cannot do it. There are some works in code. (apply by sed?)
#For the POST error you can add the method you want to use to create the index. The line 19 of the file scripts/create_index.js look like this
#`client.indices.create( {method:'PUT', index: indexName, body: schema }, function( err, res ){`

# 2. whosonfirst
#    a) download - npm run download or "npm run download -- --admin-only"
#   b) start: npm start
# 3. Geonames
#   a) download - npm run download (this will download files to dir from pelias.config)
#   NOTE: if whosonfirst download is valid, npm run start should works normal (importer geonames)
#   This takes a while (1h?)

#Kibana
# wget https://artifacts.elastic.co/downloads/kibana/kibana-5.6.14-amd64.deb
# sudo dpkg -i kibana-5.6.14-amd64.deb
# in kibana config we need to change ip address from config

# Enable elements and import elements ?
