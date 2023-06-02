#!/bin/bash

set -Eeuo pipefail

mkdir -p /tmp/bin
curl -sfLo /tmp/bin/cosign https://github.com/sigstore/cosign/releases/download/v2.0.2/cosign-linux-amd64
chmod 755 /tmp/bin/cosign
export PATH="/tmp/bin:$PATH"

if ! oc get secret code-signature -n fruits-dev &>/dev/null; then
    echo "========================================================================"
    echo " Generating a keypair"
    echo "========================================================================"
    echo

    ## Move to /tmp before creating the keypair because of:
    # Error: open cosign.pub: permission denied
    # main.go:74: error during command execution: open cosign.pub: permission denied
    cd /tmp

    COSIGN_PASSWORD=dummy cosign generate-key-pair k8s://fruits-dev/code-signature
fi

exit 0
