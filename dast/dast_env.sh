#!/bin/bash

export CONSOLE_URL=$(oc get routes console -n openshift-console -o jsonpath='{.spec.host}')

export CLUSTER_NAME=$(oc get machineset -n openshift-machine-api -o=go-template='{{(index (index .items 0).metadata.labels "machine.openshift.io/cluster-api-cluster" )}}')

export BASE_API_URL=$(oc get infrastructure -o jsonpath="{.items[*].status.apiServerURL}")
export TOKEN=$(oc whoami -t)
export NAMESPACE=${NAMESPACE:-default}

oc label ns $NAMESPACE security.openshift.io/scc.podSecurityLabelSync=false pod-security.kubernetes.io/enforce=privileged pod-security.kubernetes.io/audit=privileged pod-security.kubernetes.io/warn=privileged --overwrite
