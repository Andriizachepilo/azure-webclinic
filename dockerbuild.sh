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


#If Docker is not installed, proceed with the installation. If it is installed, proceed with building images
docker --version > /dev/null 2>&1

if [[ $? -ne 0]]; then
  echo "Docker is not installed. Installing docker"

  sudo apt-get update

  sudo apt-get install docker.io -y

  sudo systemctl start docker
  
  # Test Docker installation by running a simple container
  sudo docker run hello > /dev/null 2>&1
if [[ $? -eq 0 ]]; then

  sudo systemctl enable docker
  echo "docker has been installed succesfully"
else 
  echo "Docker installation failed. Please check and try again"
fi

else
  echo "docker is already installed "

fi


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


