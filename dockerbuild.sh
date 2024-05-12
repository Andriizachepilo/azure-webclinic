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


totalfolders=()


while IFS= read -r folder; do
    totalfolders+=($folder)
done < <(find "$dir" -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | sort)


if [[ ${#totalfolders[@]} -gt 0 ]]; then

for service in "${totalfolders[@]}"; do
    ((port++))

    docker build -t "${service}:${tag}" \
                 --build-arg JARPATH="${dir}${service}/target/${service}-3.2.4.jar" \
                 --build-arg PORT="${port}" .

done
fi

images=()

while IFS= read -r img; do
        images+=($img)
done < <(docker images | awk -v tag="$tag" '$2 == tag {print $1}')

if [[ ${#images[@]} -eq ${#totalfolders[@]} ]]; then 
echo "123"
fi
