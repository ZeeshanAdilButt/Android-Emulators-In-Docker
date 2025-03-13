#!/bin/bash

# Check if arguments were provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <device_numbers>"
    echo "Example: $0 0,5,7,9"
    echo "Example: $0 1"
    exit 1
fi

# Base host ports
BASE_VNC_PORT=6080
BASE_ADB_PORT=5555
BASE_SELENIUM_PORT=4444

# Base directory for persistent storage
DATA_DIR="/home/swarm/android-data"

# Convert comma-separated list to array
IFS=',' read -ra DEVICE_NUMBERS <<< "$1"

for i in "${DEVICE_NUMBERS[@]}"; do
    # Remove any whitespace
    i=$(echo $i | tr -d ' ')
    
    VNC_PORT=$((BASE_VNC_PORT + i))
    ADB_PORT=$((BASE_ADB_PORT + i))
    SELENIUM_PORT=$((BASE_SELENIUM_PORT + i))
    CONTAINER_NAME="device-${i}-android-cluster"
    
    echo "Stopping and removing container ${CONTAINER_NAME}..."
    docker stop ${CONTAINER_NAME} || echo "Container ${CONTAINER_NAME} not running"
    docker rm ${CONTAINER_NAME} || echo "Container ${CONTAINER_NAME} not found"
    
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

echo "All specified containers restarted with persistent storage in ${DATA_DIR}"