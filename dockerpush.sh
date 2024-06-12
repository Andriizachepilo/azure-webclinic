#!/bin/bash

container=$(az acr list --query "[].name" -o tsv)
tag=$(<tag.txt)
imagescounter=0

images=$(docker images | awk -v tag="$tag" '$2 == tag {print $1}')

for count in $images; do
  ((imagescounter++))
done

az acr login --name $container

if [[ $imagescounter -gt 0 ]]; then     

    for image in $images; do 
        docker tag "${image}:${tag}" "${container}:${image}${tag}"
        docker push "${container}:${image}${tag}"
    done
                                        
else
    echo "There are no images with tag $tag"
fi
