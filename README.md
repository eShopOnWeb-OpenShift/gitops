# GitOps Artefacts for the eShopOnWeb demo

## Deploy OpenShift resources with OpenShift GitOps

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

* Give cluster-admin access rights to the **OpenShift Gitops** operator.

```sh
oc adm policy add-cluster-role-to-user cluster-admin system:serviceaccount:openshift-gitops:openshift-gitops-argocd-application-controller
```

```sh
cp infrastructure.yaml.sample infrastructure.yaml
oc apply -f infrastructure.yaml -n openshift-gitops
```

* Print the relevant information to create the webhook.

```sh
oc get route -n eshop-dev el-eshoponweb -o go-template='https://{{.spec.host}}/{{"\n"}}'
oc get secret -n eshop-dev github-webbook-secret -o go-template --template='{{.data.secretToken|base64decode}}{{"\n"}}'
```

* Add a webhook on the **eShopOnWeb** GitHub repository.

  * Payload URL: *url above*
  * Content-Type: Application/json
  * Secret: *secret printed above*
