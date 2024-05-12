#! /bin/bash

dir="services/"
docker_hub_username="andrey342"
port=8081
tag=0

for x in $(find "$dir" -type d -mindepth 1 -maxdepth 1 -exec basename {} \;); do
((port ++ && tag ++))

docker build -t "${docker_hub_username}/${x}:${tag}" \
                 --build-arg PATH="${dir}${x}" \
                 --build-arg PORT="${port}" .

done








