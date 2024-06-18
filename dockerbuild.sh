#!/bin/bash

dir="services/"
ports=(9090 8080 8888 8806 8761 8807 8808)

# tag for docker images 
# Check if the tag.txt file exists, if it does, read the current tag, increment it, and update the file
# Otherwise create a txt file and start with tag 0
if [[ ! -f "tag.txt" ]]; then
    tag=0
    echo "$tag" > "tag.txt"
else
    tag=$(cat "tag.txt")
    ((tag++))
    echo "$tag" > "tag.txt"
fi


totalfolders=()

# count all the directories inside the specified directory and store them in the array
while IFS= read -r folder; do
    totalfolders+=($folder)
done < <(find "$dir" -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | sort)

# Check if there are any directories found
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


# Check if the number of built images matches the number of service directories
if [[ ${#images[@]} -eq ${#totalfolders[@]} ]]; then 
echo "Images have been built successfully"
else 
# If the number of folders and images do not match, decrement the tag and update the file
((tag--))
echo "$tag" > "tag.txt"
echo "Images have not been built"
fi

