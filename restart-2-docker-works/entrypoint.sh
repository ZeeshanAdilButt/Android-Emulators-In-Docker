#!/bin/bash
set -e

# Wait for KVM device
timeout=30
while [ ! -e /dev/kvm ] && [ $timeout -gt 0 ]; do
    echo "Waiting for /dev/kvm to be available... ($timeout seconds remaining)"
    sleep 1
    timeout=$((timeout - 1))
done

if [ ! -e /dev/kvm ]; then
    echo "ERROR: /dev/kvm device not found after waiting"
    exit 1
fi

# Start Xvfb
Xvfb :0 -screen 0 1280x800x24 &
sleep 2

export DISPLAY=:0
export QT_QPA_PLATFORM=xcb

# Start window manager
openbox &
sleep 1

# Start the emulator
exec /home/androidusr/docker-android/mixins/scripts/run.sh