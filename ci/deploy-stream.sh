#!/usr/bin/env sh
set -e

## Undeploy the stream

status=$(curl --write-out "%{http_code}" --silent --output /dev/null "${dataflow_server_url}/streams/deployments/${stream_name}" -i -X DELETE)

response=response.txt

if [ ${status} = "200" ]; then

    echo "Stream undeployed successfully"
    ## If undeploy goes well, deploy the stream again to ensure updated stream apps are deployed
    status=$(curl -s -w %{http_code} -o ${response} "${dataflow_server_url}/streams/deployments/${stream_name}" -i -X POST)

    if [ ${status} -lt 300 ]; then
        cat ${response}
        echo "Deployed stream ${stream_name}"
    else
        echo "Failed to deploy stream ${stream_name}"
        return -1
    fi
else

    ## If the stream doesn't exist, create and deploy it
    echo "Stream does not exist"
    status=$(curl -s -w %{http_code} -o ${response} "${dataflow_server_url}/streams/definitions" -i -X POST -d "name=${stream_name}&definition=${stream_dsl}&deploy=true")

    if [ ${status} -lt 300 ]; then
        cat ${response}
        echo "Created stream ${stream_name}"
    else
        echo "Failed to create a new stream definition ${stream_name}"
        return -1
    fi
fi
