#!/usr/bin/env bash

namespace="traefik"
helm uninstall traefik --namespace $namespace

kubectl delete \
    --filename dashboard.yaml \
    --filename certificate-staging.yaml \
    --filename certificate-production.yaml \
    --namespace $namespace

kubectl delete namespace $namespace
