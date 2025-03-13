FROM ubuntu:22.04

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install required packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        wget \
        unzip \
        openjdk-11-jdk \
        git \
        python3 \
        python3-pip \
        python3-numpy \
        android-tools-adb \
        supervisor \
        xvfb \
        x11vnc \
        novnc \
        net-tools \
        socat && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set up Android SDK
ENV ANDROID_HOME=/opt/android-sdk
ENV PATH=${PATH}:${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/emulator
ENV ANDROID_SDK_ROOT=${ANDROID_HOME}
ENV ANDROID_AVD_HOME=/root/.android/avd

# Create necessary directories and download command line tools
RUN mkdir -p ${ANDROID_HOME} && \
    cd ${ANDROID_HOME} && \
    wget https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip && \
    unzip commandlinetools-linux-*_latest.zip && \
    rm commandlinetools-linux-*_latest.zip && \
    mkdir -p cmdline-tools/latest && \
    mv cmdline-tools/bin cmdline-tools/latest/ && \
    mv cmdline-tools/lib cmdline-tools/latest/

# Accept licenses
RUN yes | sdkmanager --licenses

# Install SDK packages one by one to better handle failures
RUN sdkmanager --verbose "platform-tools" && \
    sdkmanager --verbose "platforms;android-28" && \
    sdkmanager --verbose "build-tools;28.0.3" && \
    sdkmanager --verbose "emulator"

# Install system image with retries
RUN for i in 1 2 3; do \
        sdkmanager --verbose "system-images;android-28;google_apis;x86" && break || \
        if [ $i -lt 3 ]; then \
            echo "Retry $i of 3" && sleep 5; \
        else \
            exit 1; \
        fi \
    done

# Create necessary directories
RUN mkdir -p /root/.android/avd

# Create AVDs for two emulators
RUN echo "no" | avdmanager create avd -n emulator1 -k "system-images;android-28;google_apis;x86" --device "pixel" && \
    echo "no" | avdmanager create avd -n emulator2 -k "system-images;android-28;google_apis;x86" --device "pixel"

# Set up supervisor configuration
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Create startup script
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Expose ports for noVNC and ADB
EXPOSE 5901 5902 6080 6081 5037 5554 5555 5556 5557

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]