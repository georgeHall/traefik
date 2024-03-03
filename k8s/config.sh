#!/usr/bin/env bash

namespace="traefik"
if ! kubectl get namespace $namespace
then
    kubectl create namespace $namespace
    kubectl patch namespace $namespace -p "{\"metadata\": {\"labels\": {\"name\": \"${namespace}\"}}}"
fi

if ! kubectl get secret traefik-dashboard-auth --namespace $namespace
then
    password=$(cat traefik.password.txt)
    b64password=$(htpasswd -nb admin $password | openssl base64)
    kubectl create secret generic traefik-dashboard-auth --from-literal=users=\'$b64password\' --namespace $namespace
fi


kubectl apply \
    --namespace $namespace \
    --filename ./manifests/certificate-staging.yaml \
    --filename ./manifests/certificate-production.yaml

helm upgrade --install traefik traefik/traefik \
    --namespace $namespace \
    --values values.yaml

kubectl apply \
    --namespace $namespace \
    --filename ./manifests/dashboard.yaml

