#!/bin/bash


docker="andrey342/day4"
tag=$(<tag.txt)

images=$(docker images | awk -v tag="$tag" '$2 == tag {print $1}')

for image in $images; do
docker tag "${image}" "${docker}:${image}${tag}"

docker push "${docker}:${image}${tag}"


done


