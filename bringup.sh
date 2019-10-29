#!/bin/bash
mkdir /tmp/hostpath_pv
kind create cluster --config kind/config
export KUBECONFIG="$(kind get kubeconfig-path --name="kind")"
kubectl apply -f https://git.io/kube-flannel.yaml
kubectl apply -f manifests/pv-claim.yaml
kubectl apply -f manifests/pv-deploy.yaml
kubectl scale deploy/pv-deploy --replicas=3
