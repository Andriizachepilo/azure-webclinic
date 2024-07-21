#!/bin/bash

function install_dialog {
    # Check if the system is Linux
    if [ -f "/etc/os-release" ]; then
        source /etc/os-release
        OS_NAME=$NAME
        OS_VERSION=$VERSION_ID
        
        if [[ "$OS_NAME" == "Ubuntu" || "$OS_NAME" == "Debian" ]]; then
            sudo apt-get update
            sudo apt-get install -y dialog
        elif [[ "$OS_NAME" == "Fedora" ]]; then
            sudo dnf install -y dialog
        elif [[ "$OS_NAME" == "CentOS" || "$OS_NAME" == "RHEL" ]]; then
            sudo yum install -y dialog
        else
            echo "Unsupported Linux distribution. Please install dialog manually."
            exit 1
        fi
        
    # Check if the system is macOS
    elif [ "$(uname)" == "Darwin" ]; then
        OS_NAME="macOS"
        OS_VERSION=$(sw_vers -productVersion)
        brew install dialog
        
    # Check if the system is Windows (WSL)
    elif grep -qE "(Microsoft|WSL)" /proc/version &> /dev/null; then
        OS_NAME="Windows (WSL)"
        OS_VERSION=$(wslver=$(uname -r); echo ${wslver::-2})
        sudo apt-get update
        sudo apt-get install -y dialog
        
    else
        echo "Unsupported operating system. Please install dialog manually."
        exit 1
    fi
}

# Check if dialog is installed
if ! command -v dialog &> /dev/null; then
    echo "Dialog is not installed."

    # If you want to install it. yes - trigger the function above.
    read -p "Do you want to install dialog? (y/n): " choice
    if [[ "$choice" == "y" || "$choice" == "Y" ]]; then
        install_dialog
    else
        echo "Dialog installation skipped. Exiting."
        exit 1
    fi
fi

echo "Dialog is installed and ready to use."


# Function to show the main menu
show_main_menu() {
dialog --backtitle "Docker CI/CD Script" --title "Main Menu" \
        --menu "Choose an option:" 15 60 7 \
        1 "Build Application" \
        2 "Test Application" \
        3 "Build Docker Images" \
        4 "Tag Images and Push Them to the Registry '${REGISTRY}'" \
        5 "All the Steps Above" \
        6 "Delete Built Images" \
        7 "Exit" 2> /tmp/menu_choice.txt
}

# Function to display a message box
function show_message() {
    dialog --backtitle "Docker CI/CD Script" --title "$1" --msgbox "$2" 10 50
}

# Function to handle Docker login
function docker_login {
    local ATTEMPTS=3

    while ((ATTEMPTS > 0)); do
        dialog --backtitle "Docker CI/CD Script" --insecure --passwordbox "Enter Docker password. (Attempt $ATTEMPTS)" 8 60 2> /tmp/docker_pass.txt
        DOCKER_PASS=$(< /tmp/docker_pass.txt)

        DOCKER_LOGIN=$(echo "$DOCKER_PASS" | docker login --username "$REGISTRY" --password-stdin 2>&1)
        DOCKER_CODE=$?

        if [[ $DOCKER_CODE -eq 0 ]]; then
            show_message "Docker Login" "Docker login succeeded"
            return 0
        else
            ((ATTEMPTS--))
            if [[ ATTEMPTS -gt 0 ]]; then
                show_message "Docker Login" "Docker login failed: $DOCKER_LOGIN. You have $ATTEMPTS more attempt(s)."
            else
                show_message "Docker Login" "Docker login failed: $DOCKER_LOGIN. No more attempts left."
                exit 1
            fi
        fi
    done
}

# Function to handle login for Azure or AWS and GCP
function login_azure_aws {
    local ATTEMPTS=3 
    local login_cmd=$1
    local variable=""

    case "$login_cmd" in
        "az login 2>&1")
            variable="Microsoft Azure"
            ;;
        *"az acr login"*)
            variable="Azure Container Registry"
            ;;
        *"ecr"*)
            variable="Amazon Elastic Container Registry"
            ;;
        *"aws"*)
            variable="Amazon Web Services" #####################################################################
            ;;
    esac

    while ((ATTEMPTS > 0)); do 
        dialog --backtitle "Docker CI/CD Script" --inputbox "Enter the container registry URL: (Login to ${variable})" 8 60 2> /tmp/registry.txt
        REGISTRY=$(< /tmp/registry.txt)

        eval $login_cmd
        exit_code=$?

        if [ $exit_code -eq 0 ]; then 
            show_message "Login Successful" "Login to ${variable} is successful" 
            return 0
        else 
            ((ATTEMPTS--))
            if ((ATTEMPTS > 0)); then
                show_message "Login Failed" "Failed: Login to ${variable} '$REGISTRY', you have $ATTEMPTS more attempt(s)."
            else 
                show_message "Login Failed" "Login to ${variable} failed after multiple attempts, exiting..."
                exit 1
            fi
        fi
    done
}

# Function to check the path for services
function path_checking {
    local ATTEMPTS=3

    while ((ATTEMPTS > 0)); do
        dialog --backtitle "Docker CI/CD Script" --inputbox "Enter the path to the services:" 8 60 2> /tmp/fullpath.txt
        FULLPATH=$(< /tmp/fullpath.txt)

        while IFS= read -r svc; do
            SERVICES+=("$svc")
        done < <(find "$FULLPATH" -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | sort)

        if [ "${#SERVICES[@]}" -gt 0 ]; then
            show_message "Path to the Services" "There are ${#SERVICES[@]} services found in directory $FULLPATH"
            return 0
        else 
            ((ATTEMPTS--))
            if ((ATTEMPTS == 0)); then
                show_message "Path to the Services" "No services found, exiting..."
                exit 1
            else
                show_message "Path to the Services" "No services found in directory '$FULLPATH', you have $ATTEMPTS more attempt(s)."
            fi  
        fi
    done
}

# Ask for the registry URL
dialog --backtitle "Docker CI/CD Script" \
       --inputbox "Enter the container registry URL (verify whether you use a cloud platform registry or Docker registry):\n\nExamples:\n\nAzure Container Registry: myregistry.azurecr.io\nAmazon ECR: 123456789012.dkr.ecr.us-west-2.amazonaws.com\nGoogle Container Registry: gcr.io/my-project-id\n\nPlease enter the URL:" \
       15 80 2> /tmp/registry.txt

REGISTRY=$(< /tmp/registry.txt)


if [[ -z "$REGISTRY" ]]; then
    show_message "Error" "Registry URL is not specified"
    exit 1
fi

if [[ "${REGISTRY}" == *"azurecr"* ]]; then
    # Check if Azure CLI is installed
    if ! command -v az &> /dev/null; then
        show_message "Azure CLI Error" "Azure CLI is not installed"
        exit 1
    fi

    # Attempt to log in to Azure
    AZ_LOGIN=$(az login 2>&1)
    AZ_CODE=$?

    # Check if the login was successful
    if [[ $AZ_CODE -eq 0 ]]; then
        show_message "Microsoft Azure Login" "Login to Azure succeeded. Proceeding to login to your Container Registry."
    else
        show_message "Microsoft Azure Login" "Authentication failed. Exit code is $AZ_CODE. Please try again."
        login_azure_aws "az login 2>&1"
    fi

    # Log to the registry (ACR)

    AZURE="${REGISTRY%%.*}"
    ACR_LOGIN=$(az acr login --name $AZURE 2>&1)
    ACR_CODE=$?
    if [[ $ACR_CODE -eq 0 ]]; then
        show_message "Azure Container Registry Login" "ACR login succeeded"
    else
        if [[ $ACR_LOGIN == *"get an access token"* ]]; then
            show_message "Azure Container Registry Login" "ACR login failed: Docker daemon is not running. Run Docker and try again"
            exit $ACR_CODE
        elif [[ $ACR_LOGIN == *"Looks like you don't have access to registry"* ]]; then
            show_message "Azure Container Registry Login" "$ACR_LOGIN"
            exit $ACR_CODE
        else
            show_message "Azure Container Registry Login" "Login to registry '$AZURE' failed, try again"
            login_azure_aws "az acr login --name $AZURE 2>&1"
        fi
    fi

elif [[ "${REGISTRY}" == *"amazonaws.com"* ]]; then
    # Check if AWS CLI is installed
    if ! command -v aws &> /dev/null; then
        show_message "Amazon Web Services" "AWS CLI is not installed"
        exit 1
    fi
    AWS_ECR=$(aws ecr get-login-password 2>&1)
    ECR_LOGIN_RESULT=$(echo "$AWS_ECR" | docker login -u AWS --password-stdin ${REGISTRY} 2>&1)
    ECR_CODE=$?

    if (( ECR_CODE == 0 )); then
        dialog --backtitle "Docker CI/CD Script" \
               --inputbox "Login to your registry was successful, enter your ECR repository name:" \
               8 60 2> /tmp/ecr_repo.txt
        ECR_REPO=$(< /tmp/ecr_repo.txt)

        if [[ -n "$ECR_REPO" ]]; then
            REGION=$(echo $REGISTRY | cut -d '.' -f 4)
            IF_EXISTS=$(aws ecr describe-repositories --repository-names $ECR_REPO --region $REGION 2>&1)

            if [[ $IF_EXISTS == *"does not exist"* ]]; then
                show_message "Amazon Elastic Container Registry" "ERROR: $IF_EXISTS"
                exit 1
            else
                show_message "Amazon Elastic Container Registry" "Repository ${ECR_REPO} does exist!"
                push_images "$ECR_REPO"
            fi
        else
            show_message "Amazon Elastic Container Registry" "Repository is not specified, try again (ADD FUNCTION)"
            exit 1
        fi
    else
        show_message "Amazon Web Services" "$AWS_ECR. Exit code is $ECR_CODE"
        exit 1
    fi

elif [[ $REGISTRY == *"gcr.io"* ]]; then
    # Check if Google Cloud SDK is installed
    if ! command -v gcloud &> /dev/null; then
        show_message "Google Cloud" "Google Cloud SDK is not installed"
        exit 1
    fi

    GCP_LOG=$(gcloud auth login)
    GCP_CODE=$?

    if [[ $GCP_CODE -eq 0 ]]; then
        GCR=$(gcloud auth configure-docker)
        GCR_DOCKER_CODE=$?

        if [[ $GCR_DOCKER_CODE -eq 0 ]]; then
            PROJECT_ID=$(echo $REGISTRY | cut -d '/' -f 2)
            CHECKING_PROJECT=$(gcloud projects describe $PROJECT_ID 2>&1)

            if [[ $CHECKING_PROJECT == *"not found"* ]]; then
                show_message "Google Cloud" "$PROJECT_ID does not exist, exiting..."
                exit 1
            else
                show_message "Google Cloud" "$PROJECT_ID project does exist"
                push_images "$(echo $REGISTRY | cut -d '/' -f 1-2)"
            fi
        fi
    fi
else
    docker_login
fi


# Ask for the path to the services
dialog --backtitle "Docker CI/CD Script" --inputbox "Enter the path to the services:" 8 60 2> /tmp/fullpath.txt
FULLPATH=$(< /tmp/fullpath.txt)

if [ ! -z "$FULLPATH" ]; then
    SERVICES=()
    while IFS= read -r svc; do
        SERVICES+=("$svc")
    done < <(find "$FULLPATH" -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | sort)
    if [ ${#SERVICES[@]} -gt 0 ]; then
        show_message "Path to the Services" "There are ${#SERVICES[@]} services found in directory $FULLPATH"
    else
        show_message "Path to the Services" "There are no services found in directory $FULLPATH, you have 3 more attempts"
        path_checking
    fi
else
    show_message "Path to the Services" "FULLPATH variable is not set, try again"
    path_checking
fi

# Ask for custom ports for applications
dialog --backtitle "Docker CI/CD Script" --inputbox "Enter custom ports for applications (optional, separated by space, In aplhabetical order from Admin service to visits service). If no ports specified, default ports will be applied:" 8 60 2> /tmp/custom_ports.txt
CUSTOM_PORTS=$(< /tmp/custom_ports.txt)


# Function to build the application
function build_app {
    MAVEN=$(mvn --version 2>&1)

    if [[ $MAVEN == *"not found"* ]]; then
        show_message "Build Application" "Maven is not installed"
        exit 1
    fi

    pushd "$FULLPATH"

    if [[ ! -f "pom.xml" ]]; then
        show_message "Build Application" "Pom.xml file does not exist in '$(pwd)'"
        exit 1
    elif [[ -z "pom.xml" ]]; then
        show_message "Build Application" "Pom.xml is empty"
        exit 1 
    fi

    mvn clean package -DskipTests

    if [[ $? -ne 0 ]]; then
        popd
        show_message "Build Application" "Application build failed."
        exit 1
    else
       show_message "Build Application" "The application build was successful."
    fi

    popd
    for svc in ${SERVICES[@]}; do
        pushd "${FULLPATH}/${svc}/target"
        if [[ ! -f "${svc}-3.2.4.jar" ]]; then
            popd
            show_message "Build Application" "Jar file for service ${svc} does not exist"
            exit 1
        fi
        popd
    done
}

# Function to test the application
function test_app {
    pushd "$FULLPATH"
    mvn test
    if [[ $? -ne 0 ]]; then
        show_message "Test Application" "Tests failed."
        exit 1
    else 
        show_message "Test Application" "Tests were successful."
    fi
    popd
}

if [[ ! -f "tag.txt" ]]; then 
    TAG=0
    echo "$TAG" > "tag.txt"
else
    TAG=$(cat "tag.txt")
    echo "$TAG" > "tag.txt"
fi

# Function to build Docker images with specified ports
function build_images {
    if ! command -v docker &> /dev/null; then
        show_message "Docker Check" "Docker is not installed"
        exit 1
    elif ! docker info &> /dev/null; then
        show_message "Docker Check" "Docker is not running"
        exit 1
    else
        local L_PORTS=()

        # Determine which ports to use
        if [[ ! -z "$CUSTOM_PORTS" ]]; then
            IFS=' ' read -r -a L_PORTS <<< "$CUSTOM_PORTS"
        else 
         L_PORTS+=(9090 8080 8888 8806 8761 8807 8808)
        fi

        local PORT_COUNTER=-1

        for service in "${SERVICES[@]}"; do 
            ((PORT_COUNTER++))
            docker build -t "${service}:${TAG}" \
                --build-arg JARPATH="${FULLPATH}/${service}/target/${service}-3.2.4.jar" \
                --build-arg PORT="${L_PORTS[$PORT_COUNTER]}" .
        done
        IMAGES=($(docker images | awk -v tag="$TAG" '$2 == tag {print $1}' | sort))
        show_message "Build docker images" "${#IMAGES[@]} images were built succesfully"
    fi
}



# Function to push Docker images
function push_images {
    local value=$1
    local repo="${value:-webclinic}"

    if [[ "$value" == *"gcr.io"* ]]; then 
    REGISTRY="gcr.io/$(echo $value | cut -d '/' -f 2)"
    repo="webclinic"
    fi


    IMAGES=($(docker images | awk -v tag="$TAG" '$2 == tag {print $1}' | sort))

    NOT_TAGGED=()
    if [[ ${#IMAGES[@]} -ne 0 ]]; then
        if [[ ${#IMAGES[@]} -eq ${#SERVICES[@]} ]]; then
            for image in "${IMAGES[@]}"; do   
                docker tag "${image}:${TAG}" "${REGISTRY}/$repo:${image}${TAG}"
                TAG_EXIT_CODE=$?
                if [[ $TAG_EXIT_CODE -ne 0 ]]; then
                    show_message "Push Images" "ERROR: exit code $TAG_EXIT_CODE. $image has not been tagged"
                    NOT_TAGGED+=("$image")
                else
                    docker push "${REGISTRY}/$repo:${image}${TAG}"
                    PUSH_EXIT_CODE=$?
                    if [[ $PUSH_EXIT_CODE -ne 0 ]]; then
                        show_message "Push Images" "Image ${REGISTRY}/$repo:${image}${TAG} has not been found locally"
                        exit $PUSH_EXIT_CODE
                    fi
                fi
            done
        else 
            show_message "Push Images" "ERROR: The number of images and services does not match, something went wrong"
            exit 1
        fi
    else
        show_message "Push Images" "Images with tag ${TAG} have not been found"
        exit 1
    fi

    if [[ ${#NOT_TAGGED[@]} -ne 0 ]]; then 
        show_message "Push Images" "ERROR: Images: ${NOT_TAGGED[@]} have not been tagged and pushed. Exit code $TAG_EXIT_CODE"
        exit $TAG_EXIT_CODE
    else 
# tag for docker images 
# Check if the tag.txt file exists, if it does, read the current tag, increment it, and update the file
# Otherwise create a txt file and start with tag 0
        TAG=$(cat "tag.txt")
        ((TAG++))
        echo "$TAG" > "tag.txt"
        show_message "Push Images" "SUCCESS: Images were tagged and pushed succesfully!"
    fi


}

# Function to clean up Docker Images
function clean_up_docker_images {
  TAG=$(cat "tag.txt")
  ((TAG--))
  echo "$TAG" > "tag.txt"
    show_message "Clean Up Docker Images" "Cleaning up Docker images..."
    docker images --format "{{.Repository}}:{{.Tag}}" | grep ":${TAG}$" | xargs -I {} docker rmi -f {}
    show_message "Clean Up Docker Images" "Docker images cleaned up successfully."
     TAG=$(cat "tag.txt")
    ((TAG++))
    echo "$TAG" > "tag.txt"
}


# Function to run all steps together
function all_the_steps_above {
    build_app
    test_app
    build_images
    push_images

    show_message "CI/CD Pipeline" "All steps completed successfully:\n\n1. Application built.\n2. Tests passed.\n3. Docker images built.\n4. Docker images tagged and pushed."

}

# Main loop to show menu and perform actions
while true; do
    show_main_menu
    choice=$(cat /tmp/menu_choice.txt | tr -d '\n' | tr -d '\r')

    case $choice in
        1)
            echo "Building application..."
            build_app
            ;;
        2)
            echo "Testing application..."
            test_app
            ;;
        3)
            echo "Building Docker images..."
            build_images
            ;;
        4)
            echo "Pushing Docker images..."
            push_images
            ;;
        5)
            echo "Executing all steps..."
            all_the_steps_above
            ;;
        6)
            echo "Cleaning up Docker images..."
            clean_up_docker_images
            ;;
        7)
            echo "Exiting..."
            break
            ;;
        *)
            show_message "Invalid Option" "Please select a valid option."
            ;;
    esac
done

# Clean up temporary files
rm -f /tmp/menu_choice.txt /tmp/registry.txt /tmp/fullpath.txt /tmp/custom_ports.txt /tmp/docker_pass.txt
