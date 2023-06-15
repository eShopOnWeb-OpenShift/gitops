#!/bin/bash

set -Eeuo pipefail

HELM_RELEASE_NAME=demo

if [[ "$#" -lt 1 || "$#" -gt 2 ]]; then
    echo "Usage:"
    echo "  $0 template [sync-wave]"
    echo "  $0 list"
    echo "  $0 help"
    exit 1
fi

case "$1" in
template)
    if [ -z "${2:-}" ]; then
        exec helm template "$HELM_RELEASE_NAME" infrastructure $(yq '.spec.source.helm.parameters[] | ("--set=" + .name + "=" + .value)' infrastructure.yaml)
    else
        "$0" template | sync_wave="$2" yq eval '. | select(.metadata.annotations["argocd.argoproj.io/sync-wave"] == env(sync_wave))'
    fi
    ;;
list)
    "$0" template | yq eval -Nr '.metadata.annotations["argocd.argoproj.io/sync-wave"]' | sort -g | uniq
    ;;
*)
    ;;
esac

exit 0
