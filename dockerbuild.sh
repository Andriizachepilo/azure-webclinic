#!/bin/bash

dir="services/"
port=8081
docker="andrey342/day4"

if [[ ! -f "tag.txt" ]]; then
    tag=1
    echo "$tag" > "tag.txt"
else
    tag=$(cat "tag.txt")
    ((tag++))
    echo "$tag" > "tag.txt"
fi

if 

for service in $(find "$dir" -type d -mindepth 1 -maxdepth 1 -exec basename {} \; | sort); do
    ((port++))

    docker build -t "${service}:${tag}" \
                 --build-arg JARPATH="${dir}${service}/target/${service}-3.2.4.jar" \
                 --build-arg PORT="${port}" .

   

done

echo "S"






