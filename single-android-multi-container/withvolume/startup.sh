#!/bin/bash

# Check if an argument was provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <number_of_containers>"
    echo "Example: $0 5"
    exit 1
fi

# Get number of containers from first argument
NUM_CONTAINERS=$1

# Base host ports
BASE_VNC_PORT=6080
BASE_ADB_PORT=5555
BASE_SELENIUM_PORT=4444

# Base directory for persistent storage
DATA_DIR="/home/swarm/android-data"

memoryLimit="2950m"    # 2560 MB limit
cpuLimit="1.0"         # 1 CPU
memoryswap="10240m"    # 10240 MB swap

# Create base directory if it doesn't exist
mkdir -p ${DATA_DIR}

for ((i=0; i<NUM_CONTAINERS; i++)); do
    VNC_PORT=$((BASE_VNC_PORT + i))
    ADB_PORT=$((BASE_ADB_PORT + i))
    SELENIUM_PORT=$((BASE_SELENIUM_PORT + i))
    CONTAINER_NAME="device-${i}-android-cluster"
    
    # Create and set permissions for device-specific directory
    DEVICE_DIR="${DATA_DIR}/device-${i}"
    mkdir -p ${DEVICE_DIR}
    chown 1300:1301 ${DEVICE_DIR}
    chmod 755 ${DEVICE_DIR}
    
    echo "Starting container ${CONTAINER_NAME} with:"
    echo "  - VNC port: ${VNC_PORT}"
    echo "  - ADB port: ${ADB_PORT}"
    echo "  - Selenium port: ${SELENIUM_PORT}"
    echo "  - Data directory: ${DEVICE_DIR}"
    
    docker run -d \
        -p ${VNC_PORT}:6080 \
        -p ${SELENIUM_PORT}:4444 \
        -p ${ADB_PORT}:5555 \
        -e EMULATOR_DEVICE="Nexus 4" \
        -e WEB_VNC=true \
        -e DEBUG=true \
        --device /dev/kvm:/dev/kvm \
        -v "${DEVICE_DIR}:/home/androidusr/emulator" \
        --name ${CONTAINER_NAME} \
        budtmo/docker-android:emulator_9.0
done

echo "All containers started with persistent storage in ${DATA_DIR}"