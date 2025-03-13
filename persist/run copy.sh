#!/bin/bash

# Create AVD directory structure
mkdir -p /home/androidusr/.android/avd/nexus_4_9.0.avd

# Create the .ini file for the AVD
cat > /home/androidusr/.android/avd/nexus_4_9.0.ini << EOL
avd.ini.encoding=UTF-8
path=/home/androidusr/.android/avd/nexus_4_9.0.avd
path.rel=avd/nexus_4_9.0.avd
target=android-28
hw.device.manufacturer=Google
hw.device.name=Nexus 4
skin.path=/home/androidusr/docker-android/mixins/configs/devices/skins/nexus_4
tag.display=Google APIs
tag.id=google_apis
EOL

# Create config.ini in the AVD directory
cat > /home/androidusr/.android/avd/nexus_4_9.0.avd/config.ini << EOL
PlayStore.enabled=no
abi.type=x86_64
hw.cpu.arch=x86_64
hw.cpu.ncore=4
hw.ramSize=1536M
hw.screen=multi-touch
hw.mainKeys=no
hw.trackBall=no
hw.keyboard=yes
hw.keyboard.lid=yes
hw.keyboard.charmap=qwerty2
hw.dPad=no
hw.gsmModem=yes
hw.gps=yes
hw.battery=yes
hw.accelerometer=yes
hw.audioInput=yes
hw.audioOutput=yes
hw.sdCard=yes
hw.sdCard.path=/home/androidusr/.android/avd/nexus_4_9.0.avd/sdcard.img
disk.cachePartition=yes
disk.cachePartition.size=66MB
hw.lcd.width=768
hw.lcd.height=1280
hw.lcd.depth=16
hw.lcd.density=320
hw.lcd.backlight=yes
hw.gpu.enabled=no
hw.gpu.mode=auto
hw.initialOrientation=portrait
skin.path=/home/androidusr/docker-android/mixins/configs/devices/skins/nexus_4
skin.dynamic=yes
EOL

# Remove any stale lock files
rm -rf /home/androidusr/emulator/*.lock
rm -rf /home/androidusr/.android/avd/*.lock

# Create symbolic links for necessary files
ln -sf /home/androidusr/emulator/system.img.qcow2 /home/androidusr/.android/avd/nexus_4_9.0.avd/
ln -sf /home/androidusr/emulator/vendor.img.qcow2 /home/androidusr/.android/avd/nexus_4_9.0.avd/
ln -sf /home/androidusr/emulator/userdata.img /home/androidusr/.android/avd/nexus_4_9.0.avd/
ln -sf /home/androidusr/emulator/userdata-qemu.img /home/androidusr/.android/avd/nexus_4_9.0.avd/
ln -sf /home/androidusr/emulator/cache.img /home/androidusr/.android/avd/nexus_4_9.0.avd/
ln -sf /home/androidusr/emulator/hardware-qemu.ini /home/androidusr/.android/avd/nexus_4_9.0.avd/

# Ensure proper permissions
chown -R androidusr:androidusr /home/androidusr/.android

# Run the original startup script
export ANDROID_AVD_HOME=/home/androidusr/.android/avd
export ANDROID_SDK_ROOT=/opt/android
export PATH=$PATH:/opt/android/emulator

/home/androidusr/docker-android/mixins/scripts/run.sh