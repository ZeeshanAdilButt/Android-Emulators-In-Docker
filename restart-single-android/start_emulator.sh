# #!/bin/bash
# set -e

# echo "Adjusting /dev/kvm permissions..."
# chown root:kvm /dev/kvm || true
# chmod 660 /dev/kvm || true

# # Force HOME to point to /home/androidusr so that the AVD files are found.
# export HOME=/home/androidusr
# echo "HOME is set to: $HOME"

# echo "Starting emulator..."
# exec emulator @nexus_5_9.0 -gpu swiftshader_indirect -accel on -verbose

