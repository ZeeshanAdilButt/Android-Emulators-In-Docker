# Use Ubuntu 20.04 as the base image
FROM ubuntu:20.04

# Avoid interactive prompts during package installs
ENV DEBIAN_FRONTEND=noninteractive

# Install required packages
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    openjdk-11-jdk \
    supervisor \
    lib32stdc++6 \
    lib32z1 \
    xvfb \
    fluxbox \
    x11vnc \
    novnc \
    websockify \
    && rm -rf /var/lib/apt/lists/*

# Set environment variables for Android SDK
ENV ANDROID_SDK_ROOT=/opt/android-sdk
ENV PATH=$PATH:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$ANDROID_SDK_ROOT/platform-tools:$ANDROID_SDK_ROOT/emulator

# Download and install Android SDK command line tools
RUN mkdir -p $ANDROID_SDK_ROOT && cd $ANDROID_SDK_ROOT && \
    wget https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip -O tools.zip && \
    unzip tools.zip -d tmp && \
    rm tools.zip && \
    mkdir -p cmdline-tools/latest && \
    mv tmp/cmdline-tools/* cmdline-tools/latest/ && \
    rm -rf tmp


# Accept licenses and install required SDK components
RUN yes | sdkmanager --sdk_root=$ANDROID_SDK_ROOT \
    "emulator" \
    "platform-tools" \
    "platforms;android-28" \
    "system-images;android-28;google_apis;x86_64"

# Create two Android Virtual Devices (AVDs) using Android 9.0 (API 28)
RUN echo "no" | avdmanager create avd -n emulator1 -k "system-images;android-28;google_apis;x86_64" --force
RUN echo "no" | avdmanager create avd -n emulator2 -k "system-images;android-28;google_apis;x86_64" --force

# Copy the Supervisor configuration file into the container
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Expose emulator ports, VNC ports, and noVNC web ports
# Emulator1: 5554 (console) and 5555 (ADB)
# Emulator2: 5564 (console) and 5565 (ADB)
# VNC: 5900 (emulator1) and 5901 (emulator2)
# noVNC: 8080 (emulator1) and 8081 (emulator2)
EXPOSE 5554 5555 5564 5565 5900 5901 8080 8081

# Start Supervisor (which will launch all processes)
CMD ["/usr/bin/supervisord", "-n"]
