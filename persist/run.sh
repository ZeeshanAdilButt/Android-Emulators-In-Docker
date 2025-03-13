!/bin/bash

# Create AVD structure if it doesn't exist
# mkdir -p /home/androidusr/.android/avd/nexus_4_9.0.avd

# # Copy emulator files if they don't exist in AVD
# if [ ! -f /home/androidusr/.android/avd/nexus_4_9.0.avd/config.ini ]; then
#     cp -r /home/androidusr/emulator/* /home/androidusr/.android/avd/nexus_4_9.0.avd/
# fi

# Remove any stale lock files
rm -rf /home/androidusr/emulator/*.lock
rm -rf /home/androidusr/.android/avd/*.lock

# Remove lock files
rm -rf /home/androidusr/emulator/*.lock

# Remove leftover PID or temporary files (if they exist)
rm -f /home/androidusr/emulator/*.pid

# Remove snapshots if they exist (depending on how budtmo sets up AVD)
rm -rf /home/androidusr/.android/avd/*/snapshots/
rm -rf /home/androidusr/android_emulator_home/snapshots/

# Ensure proper permissions
chown -R androidusr:androidusr /home/androidusr/.android

# Run the original startup script
/home/androidusr/docker-android/mixins/scripts/run.sh
