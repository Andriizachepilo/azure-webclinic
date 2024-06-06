#!/bin/bash


container=$(az acr list --query "[].name" -o table) 
tag=$(<tag.txt)

images=$(docker images | awk -v tag="$tag" '$2 == tag {print $1}')

az acr login --name $container


for image in $images; do
docker tag "${image}:${tag}" "${container}:${image}${tag}"

docker push "${container}:${image}${tag}"

done


