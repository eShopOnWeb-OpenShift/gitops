# GitOps Artefacts for the MAD Roadshow France 2023

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

## Create the Helm repository

```sh
sudo dnf install awscli2 rclone
aws configure
aws s3api list-buckets --output text
aws s3api create-bucket --bucket mad-roadshow-france-2023-helm-charts --create-bucket-configuration LocationConstraint=eu-west-3 --region eu-west-3
aws s3api put-public-access-block --bucket "mad-roadshow-france-2023-helm-charts" --public-access-block-configuration "BlockPublicPolicy=false"
aws s3api put-bucket-policy --bucket mad-roadshow-france-2023-helm-charts --policy '{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": [
                "s3:GetObject"
            ],
            "Resource": [
                "arn:aws:s3:::mad-roadshow-france-2023-helm-charts/*"
 
            ]
        }
    ]
}'
rclone config
rclone ls aws:mad-roadshow-france-2023-helm-charts
```

## Deploy Postgres CrunchyDB

1. Create a namespace ***preprod-database***
2. Install the crunchyDB operator
3. run oc apply -k kustomize/postgres

More details here : https://access.crunchydata.com/documentation/postgres-operator/5.3.1/quickstart/


