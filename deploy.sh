#!/bin/bash

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