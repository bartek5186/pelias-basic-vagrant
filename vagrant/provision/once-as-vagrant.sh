#!/usr/bin/env bash

info "Provision-script user: `whoami`"

info "Install Pelias dependencies"

# @todo there should be names from config
for repository in schema whosonfirst geonames openaddresses openstreetmap polylines api placeholder interpolation pip-service; do
	git clone https://github.com/pelias/${repository}.git # clone from Github
	pushd $repository > /dev/null                         # switch into importer directory
	npm install                                           # install npm dependencies
	popd > /dev/null                                      # return to code directory
done


info "Install Schema, fix and create_index on ElasticSearch"
sed -i "s/client.indices.create( { index: indexName, body: schema }/client.indices.create( {method: 'PUT', index: indexName, body: schema }/g" scripts/create_index.js
./schema/bin/create_index


info "Create bash-alias 'app' for vagrant user"
echo 'alias app="cd /app"' | tee /home/vagrant/.bash_aliases

info "Enabling colorized prompt for guest console"
sed -i "s/#force_color_prompt=yes/force_color_prompt=yes/" /home/vagrant/.bashrc
