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

for x in $(find "$dir" -type d -mindepth 1 -maxdepth 1 -exec basename {} \; | sort); do
    ((port++))

    docker build -t "${x}:${tag}" \
                 --build-arg JARPATH="${dir}${x}/target/${x}-3.2.4.jar" \
                 --build-arg PORT="${port}" .

    docker tag "${x}:${tag}" "${docker}:${x}${tag}"

done

echo "S"






