#!/bin/bash

EMULATOR_NUM=$1
DISPLAY_NUM=$EMULATOR_NUM
PORT=$((5554 + ($EMULATOR_NUM - 1) * 2))

export DISPLAY=:$DISPLAY_NUM

# Start the emulator with appropriate configuration
emulator \
    -avd emulator$EMULATOR_NUM \
    -no-boot-anim \
    -no-window \
    -no-audio \
    -gpu swiftshader_indirect \
    -port $PORT \
    -qemu -enable-kvm