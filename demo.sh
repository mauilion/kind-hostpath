#!/usr/bin/env bash

########################
# include the magic
########################
. lib/demo-magic.sh


########################
# Configure the options
########################

#
# speed at which to simulate typing. bigger num = faster
#
TYPE_SPEED=200

#
# custom prompt
#
# see http://www.tldp.org/HOWTO/Bash-Prompt-HOWTO/bash-prompt-escape-sequences.html for escape sequences
#
DEMO_PROMPT="${GREEN}➜ ${CYAN}\W "

export KUBECONFIG="$(kind get kubeconfig-path --name="kind")"
clear


# put your demo awesomeness here
#if [ ! -d "stuff" ]; then
#  pe "mkdir stuff"
#fi

#pe "cd stuff"

p "We've configured this cluster to bindmount /tmp/hostpath_pv on each worker node"
pe "cat kind/config"
p "This means that any pvc created using the default hostpath provisioner will be created on all worker nodes"
p "let's take a look at what that means"
pe "kubectl apply -f manifests/pv-claim.yaml"
pe "kubectl apply -f manifests/pv-deploy.yaml"
p "let's put something in the index.html"
export POD=$(kubectl get pod --no-headers -o name)
kubectl exec $POD -- bash -c "echo hello > /usr/share/nginx/html/index.html"
p "kubectl exec $POD -- bash -c 'echo hello > /usr/share/nginx/index.html'"
p "let's make sure we can see the result of that change"
export SELFLINK=$(kubectl get pod -o yaml | grep selfLink...api | awk '{print $2"/proxy"}')
pe "kubectl get --raw $SELFLINK"
pe "kubectl scale deploy/pv-deploy --replicas=3"
p "now for the fun bit each of the pods sees the same content!"
pe "kubectl get pods -o wide"
pe "kubectl get pods -o yaml | grep selfLink...api | awk '{print \$2}'| xargs -I {} kubectl get --raw {}/proxy"
pe "kind get nodes | grep -v control | xargs -I {} docker exec {} find /tmp/hostpath_pv"
# show a prompt so as not to reveal our true nature after
# the demo has concluded
p ""
