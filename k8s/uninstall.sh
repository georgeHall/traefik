#!/usr/bin/env bash

namespace="traefik"
helm uninstall traefik --namespace $namespace

kubectl delete \
    --filename ./manifests/dashboard.yaml \
    --filename ./manifests/certificate-staging.yaml \
    --filename ./manifests/certificate-production.yaml \
    --namespace $namespace

kubectl delete namespace $namespace
