#!/usr/bin/env sh
set -e

## Undeploy the stream

response_code=$(curl --write-out "%{http_code}" --silent --output /dev/null "${dataflow_server_url}/streams/deployments/${stream_name}" -i -X DELETE)

if [ ${response_code} = "200" ]; then

    ## If undeploy goes well, deploy the stream again to ensure updated stream apps are deployed
    curl "${dataflow_server_url}/streams/deployments/${stream_name}" -i -X POST

else

    ## If the stream doesn't exist, create and deploy it
    curl "${dataflow_server_url}/streams/definitions" -i -X POST -d "name=${stream_name}&definition=${stream_dsl}&deploy=true"

fi
