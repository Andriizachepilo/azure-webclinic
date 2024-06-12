#!/bin/bash

dir="services/"
ports=(9090 8080 8888 8806 8761 8807 8808)


if [[ ! -f "tag.txt" ]]; then
    tag=0
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

    docker build -t "${service}:${tag}" \
                 --build-arg JARPATH="${dir}${service}/target/${service}-3.2.4.jar" \
                 --build-arg PORT="${port}" .
done
else     
    echo "There are no directories found"       
fi

images=()

while IFS= read -r img; do 
        images+=($img)
done < <(docker images | awk -v tag="$tag" '$2 == tag {print $1}')

if [[ ${#images[@]} -eq ${#totalfolders[@]} ]]; then 
echo "Images have been built successfully"
else 
((tag--))
echo "$tag" > "tag.txt"
echo "Images have not been built"
fi

