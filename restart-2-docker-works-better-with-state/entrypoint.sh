#!/bin/bash
set -e

echo "Starting container with debug info..."

# Debug information
echo 'Debug: KVM device info:'
ls -l /dev/kvm || echo 'KVM device not found'
echo 'Debug: Current user info:'
id

# Only clean lock files, not the state
echo "Cleaning up lock files only..."
find /home/androidusr/.android/avd/ -name "*.lock" -delete 2>/dev/null || true
find /home/androidusr/emulator/ -name "*.lock" -delete 2>/dev/null || true
find /home/androidusr/emulator/ -name "*.pid" -delete 2>/dev/null || true

# Create snapshot directory if it doesn't exist
mkdir -p /home/androidusr/.android/avd/*/snapshots/ 2>/dev/null || true
mkdir -p /home/androidusr/android_emulator_home/snapshots/ 2>/dev/null || true

# Start Xvfb
echo "Starting Xvfb..."
Xvfb :0 -screen 0 1280x800x24 &
sleep 2

export DISPLAY=:0
export QT_QPA_PLATFORM=xcb

# Start window manager
echo "Starting window manager..."
openbox &
sleep 1

# Start the emulator with snapshot saving enabled
echo "Starting Android emulator with state preservation..."
if [ -f /home/androidusr/android_emulator_home/snapshots/default_boot.snapshot ]; then
  echo "Found previous snapshot, loading it..."
  exec /home/androidusr/docker-android/mixins/scripts/run.sh -snapshot default_boot -no-snapshot-save
else
  echo "No previous snapshot found, creating new state..."
  # Start emulator normally and create a snapshot on exit
  trap 'echo "Saving emulator state..."; /home/androidusr/emulator/emulator -avd nexus_5_8.1 -snapshot default_boot -no-window -no-snapshot-load -no-audio -no-boot-anim' EXIT
  exec /home/androidusr/docker-android/mixins/scripts/run.sh -no-snapshot-load
fi