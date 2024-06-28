#!/bin/bash

DIR="services/"
PORTS=(9090 8080 8888 8806 8761 8807 8808)

# tag for docker images 
# Check if the tag.txt file exists, if it does, read the current tag, increment it, and update the file
# Otherwise create a txt file and start with tag 0
if [[ ! -f "tag.txt" ]]; then
    TAG=0
    echo "$TAG" > "tag.txt"
else
    TAG=$(cat "tag.txt")
    ((TAG++))
    echo "$TAG" > "tag.txt"
fi


TOTAL_FOLDERS=()

# count all the directories inside the specified directory and store them in the array
while IFS= read -r folder; do
    TOTAL_FOLDERS+=($folder)
done < <(find "$DIR" -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | sort)


# Check if there are any directories found
if [[ ${#TOTAL_FOLDERS[@]} -gt 0 ]]; then

# Index for the variable "PORT" used in the Dockerfile. This will be utilized to iterate through the PORTS array.
# Initialized to -1 so that it starts from index 0 on the first iteration.
index=-1

for service in "${TOTAL_FOLDERS[@]}"; do
(( index++ )) #first iteration will be 0 so it will get first index which is port "9090" in the array
    docker build -t "${service}:${TAG}" \
                 --build-arg JARPATH="${DIR}${service}/target/${service}-3.2.4.jar" \
                 --build-arg PORT="${PORTS[$index]}" .
done
else     
    echo "There are no directories found" 
    exit 1      
fi

IMAGES=()

while IFS= read -r img; do 
        IMAGES+=($img)
done < <(docker images | awk -v TAG="$TAG" '$2 == TAG {print $1}')


# Check if the number of built images matches the number of service directories
if [[ ${#IMAGES[@]} -eq ${#TOTAL_FOLDERS[@]} ]]; then 
echo "Images have been built successfully"
else 
# If the number of folders and images do not match, decrement the tag and update the file
((TAG--))
echo "$TAG" > "tag.txt"
echo "Images have not been built"
exit 1
fi

