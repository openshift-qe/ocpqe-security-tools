#!/bin/bash

source dast_env.sh 

echo "$CONSOLE_URL"
#curl -k "https://${CONSOLE_URL}/api/kubernetes/openapi/v2" -H "Cookie: openshift-session-token=${TOKEN}"  -H "Accept: application/json"  >> openapi.json
mkdir results 

counter=0
#for api_doc in $(kubectl api-versions); do
for api_doc in ${API_URL_LIST}; do
  echo "api doc $api_doc"
  # export API_URL="https://raw.githubusercontent.com/paigerube14/ocp-qe-perfscale-ci/ssml/apidocs/$api_doc"
  if [[ "$api_doc" == *"/"* ]]; then
    export API_URL="$BASE_API_URL/openapi/v3/apis/$api_doc"
  else   # e.g. 'v1'
    export API_URL="$BASE_API_URL/openapi/v3/api/$api_doc"
  fi
  
  echo "api url: $API_URL"
  #edit rapidast config file
  envsubst < config.yaml.template > config.yaml
  python rapidast.py --config config.yaml
done

python find_alert_types.py
high_alert_status=$(echo $?)
echo "high alert return status $high_alert_status"
if [ $phase != "Succeeded" ]; then
    echo "Pod $rapidast_pod failed. Look at pod logs in archives (results/*/pod_logs.out)"
    exit 1
fi

exit $high_alert_status