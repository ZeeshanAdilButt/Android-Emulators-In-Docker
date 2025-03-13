# First stop and remove current container
docker stop device-21-android-cluster
docker rm device-21-android-cluster

# Create directory with correct permissions
sudo mkdir -p /home/swarm/android-data/device-21
sudo chown 1300:1301 /home/swarm/android-data/device-21
sudo chmod 755 /home/swarm/android-data/device-21

# Start container with correct mount point
docker run -d \
    -v "/home/swarm/android-data/device-21:/home/androidusr/emulator" \
    -p 6100:6080 \
    -p 5575:5555 \
    -e EMULATOR_DEVICE="Nexus 4" \
    -e WEB_VNC=true \
    -e DEBUG=true \
    --device /dev/kvm:/dev/kvm \
    --name device-21-android-cluster \
    budtmo/docker-android:emulator_9.0