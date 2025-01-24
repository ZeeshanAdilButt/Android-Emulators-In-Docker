#!/bin/bash

AVD_NAME=${AVD_NAME:-SWARM4}
AVD_PATH="$HOME/.android/avd/${AVD_NAME}.ini"

if [ ! -f "$AVD_PATH" ]; then
    echo "AVD $AVD_NAME does not exist. Creating..."
    echo "no" | avdmanager create avd -n "$AVD_NAME" -k "system-images;android-28;default;x86_64" --device "pixel_2"
else
    echo "AVD $AVD_NAME already exists. Skipping creation."
fi

echo "Starting ADB nodaemon server..."
adb -a -P 5037 nodaemon server &

echo "Starting emulator $AVD_NAME on port $PORT..."
exec emulator -avd "$AVD_NAME" -port "$PORT" -no-window -gpu off -qemu -enable-kvm
