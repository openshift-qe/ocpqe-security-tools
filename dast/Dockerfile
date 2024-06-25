FROM quay.io/openshifttest/python:3.9

LABEL vendor="Red Hat Inc." maintainer="OCP QE Team"

RUN curl -sSL https://mirror.openshift.com/pub/openshift-v4/clients/ocp/stable/openshift-client-linux.tar.gz | tar -xvzf -  &&\
    mv oc /bin && mv kubectl /bin && apt-get update && apt-get install -y gettext-base uuid-runtime jq openssh-client sshpass && \
    ln -s /bin/bash /usr/bin/bash && /usr/local/bin/python -m pip install --upgrade pip && pip install virtualenv jq

RUN HELM_DIR=$(mktemp -d) && curl -sS -L https://get.helm.sh/helm-v3.11.2-linux-amd64.tar.gz | tar -xzC ${HELM_DIR}/ linux-amd64/helm  &&\
    ${HELM_DIR}/linux-amd64/helm version && mv ${HELM_DIR}/linux-amd64/helm /bin/helm


RUN helm version