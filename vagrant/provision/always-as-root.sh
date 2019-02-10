#!/usr/bin/env bash

function info {
  echo " "
  echo "--> $1"
  echo " "
}

#@todo restart and run rest services (kabana, api, etc)
info "Restart web-stack"
service nginx restart
service elasticsearch restart

info "Palias - Hello Dev!"
echo "Provision-script user: `whoami`"
echo "IP: 192.168.66.66"
