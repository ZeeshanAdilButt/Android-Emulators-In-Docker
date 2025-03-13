#!/bin/bash
# Base host ports
BASE_VNC_PORT=6080
BASE_ADB_PORT=5555
BASE_SELENIUM_PORT=4444

memoryLimit="2560m"    # 2560 MB limit
cpuLimit="1.0"         # 1 CPU
memoryswap="10240m"    # 10240 MB swap

# Number of containers to run
NUM_CONTAINERS=5

for ((i=0; i<NUM_CONTAINERS; i++)); do
  VNC_PORT=$((BASE_VNC_PORT + i))
  ADB_PORT=$((BASE_ADB_PORT + i))
  SELENIUM_PORT=$((BASE_SELENIUM_PORT + i))
  CONTAINER_NAME="device-${i}-android-cluster"
  
  echo "Starting container ${CONTAINER_NAME} with VNC port ${VNC_PORT}, ADB port ${ADB_PORT} and Selenium port ${SELENIUM_PORT}..."
  
  # docker run -it --memory=2560m --memory-swap=10240m --cpus=1.0 -p 6080:6080 -p 5555:5555 -e EMULATOR_DEVICE="Nexus 4" -e WEB_VNC=true -e DEBUG=true --device /dev/kvm --name device-0-android-v2 budtmo/docker-android:emulator_9.0

  # docker run -it --memory=2560m --memory-swap=10240m --cpus=1.0 -p 6081:6080 -p 5556:5555 -e EMULATOR_DEVICE="Nexus 4" -e WEB_VNC=true -e DEBUG=true --device /dev/kvm --name device-1-android-v2 budtmo/docker-android:emulator_9.0
    
    docker run -d \
        --memory=${memoryLimit} \
        --memory-swap=${memoryswap} \
        --cpus=${cpuLimit} \
        -p ${VNC_PORT}:6080 \
        -p ${SELENIUM_PORT}:4444 \
        -p ${ADB_PORT}:5555 \
        -e EMULATOR_DEVICE="Nexus 4" \
        -e WEB_VNC=true \
        -e DEBUG=true \
        --device /dev/kvm \
        --name ${CONTAINER_NAME} \
        budtmo/docker-android:emulator_9.0
done

echo "All containers started."
