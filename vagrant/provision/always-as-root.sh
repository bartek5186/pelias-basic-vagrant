#!/usr/bin/env bash

function info {
  echo " "
  echo "--> $1"
  echo " "
}

#@todo restart and run rest services (kabana, api, etc)
info "Restart Pelias"
service elasticsearch restart
service pelias.pip restart
service pelias.libpostal restart
service pelias.placeholder restart
service pelias.api restart

info "Palias - Hello Dev!"
echo "Provision-script user: `whoami`"
echo "IP: 192.168.66.66"
