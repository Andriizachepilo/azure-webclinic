#!/bin/bash

az aks get-credentials --resource-group webclinic --name aks-webclinic --overwrite-existing
node1=$(kubectl get nodes --show-labels | awk '{print $1}')
kubectl label node $node1 type=Internal

node2=$(kubectl get nodes --show-labels | awk '{print $2}')
kubectl label node $node2 type=Public

cd kubernetes

kubectl apply -f config-deployment.yaml 
kubectl apply -f config-service.yaml 

kubectl apply -f discovery-deployment.yaml
kubectl apply -f discovery-service.yaml

kubectl apply -f admin-deployment.yaml 
kubectl apply -f admin-service.yaml 

kubectl apply -f api-gateway-deployment.yaml
kubectl apply -f api-gateway-service.yaml 

kubectl apply -f vets-deployment.yaml
kubectl apply -f vets-service.yaml

kubectl apply -f visits-deployment.yaml
kubectl apply -f visits-service.yaml

kubectl apply -f customers-deployment.yaml
kubectl apply -f customers-service.yaml