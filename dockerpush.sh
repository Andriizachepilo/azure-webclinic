#!/bin/bash

ACR_URL="acrukwestuniq.azurecr.io"
TAG=$(<tag.txt)
IMAGES_COUNTER=0

images=$(docker images | awk -v tag="$TAG" '$2 == tag {print $1}' | sort)

for count in $images; do
  ((IMAGES_COUNTER++))
done


if [[ $IMAGES_COUNTER -gt 0 ]]; then       

    for image in $images; do 
        docker tag "${image}:${TAG}" "${ACR_URL}/webclinic:${image}${TAG}"
        docker push "${ACR_URL}/webclinic:${image}${TAG}"
    done
                                        
else
    echo "There are no images with tag $TAG"  
    exit 1
fi