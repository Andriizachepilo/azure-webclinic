#!/bin/bash

cd kubernetes

kubectl deploy -f config-deployment.yaml 
kubectl deploy -f config-service.yaml 

kubectl deploy -f discovery-deployment.yaml
kubectl deploy -f descovery-serivce.yaml

kubectl deploy -f admin-deployment.yaml 
kubectl deploy -f admin-service.yaml 

kubectl deploy -f api-gateway-deployment.yaml
kubectl deploy -f api-gateway-service.yaml 

kubectl deploy -f vets-deployment.yaml
kubectl deploy -f vets-service.yaml

kubectl deploy -f visits-deployment.yaml
kubectl deploy -f visits-service.yaml

kubectl deploy -f customers-deployment.yaml
kubectl deploy -f customers-service.yaml