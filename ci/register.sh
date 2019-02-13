#!/usr/bin/env sh
set -e
cd ${build_path}

version=$(find . -name "*.jar" | xargs basename | sed 's|[^0-9]*\(.*\)\.jar|\1|')
file_name=$(ls ${app_name}*.jar)

response=response.txt

## Unregister old stream app
status=$(curl -s -w %{http_code} -o ${response} "${dataflow_server_url}/apps/${app_type}/${app_name}" -i -X DELETE)
if [ ${status} -lt 300 ]; then
    cat ${response}
    echo "Unregistered ${app_type} / ${app_name}"
else
    echo "Failed to unregister ${app_type} / ${app_name}"
fi

## Register a new stream app
status=$(curl -s -w %{http_code} -o ${response} "${dataflow_server_url}/apps/${app_type}/${app_name}" -i -X POST -d "uri=${artifactory_url}/${repository}/${file_name}")
if [ ${status} -lt 300 ]; then
    cat ${response}
    echo "Registered ${app_type} / ${app_name}"
else
    echo "Failed to register ${app_type} / ${app_name}"
    return -1
fi
