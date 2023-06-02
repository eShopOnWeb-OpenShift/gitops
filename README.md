# GitOps Artefacts for the MAD Roadshow France 2023

## Pre-requisites

* Install the OpenShift GitOps operator.

* Fix the ArgoCD ingress route in order to use the router default TLS certificate.

```sh
oc patch argocd openshift-gitops -n openshift-gitops -p '{"spec":{"server":{"insecure":true,"route":{"enabled": true,"tls":{"termination":"edge","insecureEdgeTerminationPolicy":"Redirect"}}}}}' --type=merge
```

* Get the Webhook URL of your OpenShift Gitops installation

```sh
oc get route -n openshift-gitops openshift-gitops-server -o jsonpath='https://{.spec.host}/api/webhook'
```

* Add a webhook to your GitHub/GitLab repo

  * Payload URL: *url above*
  * Content-Type: Application/json

* Create the required namespaces.

```sh
oc new-project fruits-dev
```

* Label the `fruits-dev` namespace with argocd annotations

```sh
oc label namespace fruits-dev argocd.argoproj.io/managed-by=openshift-gitops
```

* Give admin access rights on the **fruits-dev** namespace to the **OpenShift Gitops** operator.

```sh
oc adm policy add-role-to-user admin -n fruits-dev system:serviceaccount:openshift-gitops:openshift-gitops-argocd-application-controller
```


## Deploy Postgres CrunchyDB

1. Create a namespace ***preprod-database***
2. Install the crunchyDB operator
3. run oc apply -k kustomize/postgres

More details here : https://access.crunchydata.com/documentation/postgres-operator/5.3.1/quickstart/


