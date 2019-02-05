#!/usr/bin/env sh
set -e
cd ${build_path}

version=$(find . -name "*.jar" | xargs basename | sed 's|[^0-9]*\(.*\)\.jar|\1|')
file_name=$(ls ${app_name}*.jar)

response=response.txt

## Create a new app version on dataflow server
status=$(curl -s -w %{http_code} -o ${response} "${dataflow_server_url}/apps/${app_type}/${app_name}" -i -X POST -d "uri=${artifactory_url}/${repository}/${file_name}")
if [ ${status} -lt 300 ]; then
    cat ${response}
else
    echo "Failed to register a new app version"
    return -1
fi

## Make new version default
status=$(curl -s -w %{http_code} -o ${response} "${dataflow_server_url}/apps/${app_type}/${app_name}" -i -X PUT -H 'Accept: application/json')
if [ ${status} -lt 300 ]; then
    cat ${response}
else
    echo "Failed to set new version as default"
    return -1
fi