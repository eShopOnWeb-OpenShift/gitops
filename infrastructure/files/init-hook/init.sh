#!/bin/bash

set -Eeuo pipefail

mkdir -p /tmp/bin
curl -sSfL -o /tmp/bin/yq https://github.com/mikefarah/yq/releases/download/v4.34.1/yq_linux_amd64
curl -sSfL -o /tmp/bin/cosign https://github.com/sigstore/cosign/releases/download/v2.0.2/cosign-linux-amd64
curl -sLo /tmp/bin/jq https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64
chmod 755 /tmp/bin/cosign /tmp/bin/yq /tmp/bin/jq
export PATH="/tmp/bin:$PATH"

if ! oc get secret code-signature -n eshop-infra &>/dev/null; then
    echo "========================================================================"
    echo " Generating a keypair for code signature with cosign"
    echo "========================================================================"
    echo

    ## Move to /tmp before creating the keypair because of:
    # Error: open cosign.pub: permission denied
    # main.go:74: error during command execution: open cosign.pub: permission denied
    cd /tmp

    COSIGN_PASSWORD=dummy cosign generate-key-pair k8s://eshop-infra/code-signature
fi

echo
echo "========================================================================"
echo " Distributing the code signature keypair to relevant namespaces"
echo "========================================================================"
echo

oc get secret code-signature -n eshop-infra -o yaml | yq eval 'del(.status, .metadata.resourceVersion, .metadata.uid, .metadata.namespace, .metadata.creationTimestamp, .metadata.selfLink, .metadata.managedFields)' - > /tmp/code-signature-secret.yaml
oc apply -f /tmp/code-signature-secret.yaml -n eshop-dev
oc apply -f /tmp/code-signature-secret.yaml -n stackrox

echo
echo "========================================================================"
echo " Distributing the Stackrox CI/CD token to relevant namespaces"
echo "========================================================================"
echo

while ! oc get secret stackrox-cicd-token -n stackrox &>/dev/null; do
    echo "Secret not yet created..."
    sleep 5

done

oc get secret stackrox-cicd-token -n stackrox -o yaml | yq eval 'del(.status, .metadata.resourceVersion, .metadata.uid, .metadata.namespace, .metadata.creationTimestamp, .metadata.selfLink, .metadata.managedFields)' - > /tmp/cicd-token-secret.yaml
oc apply -f /tmp/cicd-token-secret.yaml -n eshop-dev

exit 0
