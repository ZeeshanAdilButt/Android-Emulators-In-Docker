# #!/bin/bash

# AVD_NAME=${AVD_NAME:-SWARM4}
# AVD_PATH="$HOME/.android/avd/${AVD_NAME}.ini"


# if [ ! -f "$AVD_PATH" ]; then
#     echo "AVD $AVD_NAME does not exist. Creating..."
#     echo "no" | avdmanager create avd -n "$AVD_NAME" -k "system-images;android-28;default;x86_64" --device "pixel_2"
# else
#     echo "AVD $AVD_NAME already exists. Skipping creation."
# fi

# echo "Starting ADB nodaemon server..."
# adb -a -P 5037 nodaemon server &

# echo "Starting emulator $AVD_NAME on port $PORT..."
# exec emulator -avd "$AVD_NAME" -port "$PORT" -no-window -gpu off -qemu -enable-kvm


#!/bin/bash

AVD_NAME=${AVD_NAME:-SWARM4}
PORT=${PORT:-5554}
AVD_PATH="$HOME/.android/avd/${AVD_NAME}.ini"

# Start VNC and noVNC
Xvfb :1 -screen 0 1280x720x16 &
export DISPLAY=:1
x11vnc -display :1 -forever -rfbport 5900 &
websockify --web /usr/share/novnc/ 6080 localhost:5900 &

# Create AVD if doesn't exist
if [ ! -f "$AVD_PATH" ]; then
    echo "Creating AVD $AVD_NAME..."
    echo "no" | avdmanager create avd -n "$AVD_NAME" -k "system-images;android-28;default;x86_64" --device "pixel_2"
fi

# Start ADB and emulator
adb -a -P 5037 server nodaemon &
exec emulator -avd "$AVD_NAME" -port "$PORT" -no-window -gpu swiftshader_indirect -no-audio