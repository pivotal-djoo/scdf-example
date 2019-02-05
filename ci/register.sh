#!/usr/bin/env sh
set -e
cd ${build_path}

version=$(find . -name "*.jar" | xargs basename | sed 's|[^0-9]*\(.*\)\.jar|\1|')
file_name=$(ls ${app_name}*.jar)

## Create a new app version on dataflow server
curl "${dataflow_server_url}/apps/${app_type}/${app_name}/${version}" -i -X POST -d "uri=${artifactory_url}/${repository}/${file_name}"

## Make new version default
curl "${dataflow_server_url}/apps/${app_type}/${app_name}/${version}" -i -X PUT -H 'Accept: application/json'
