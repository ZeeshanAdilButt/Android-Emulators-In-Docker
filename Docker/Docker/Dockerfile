FROM ubuntu:20.04

ARG SDK_VERSION=commandlinetools-linux-11076708_latest.zip
ARG ANDROID_BUILD_VERSION=28
ARG ANDROID_TOOLS_VERSION=33.0.2

ENV ANDROID_HOME=/opt/android-sdk
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV PATH=${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/emulator:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${PATH}
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    unzip \
    curl \
    openjdk-17-jdk \
    libglu1-mesa \
    x11vnc \
    xvfb \
    libc6 \
    libstdc++6 \
    libgcc1 \
    zlib1g \
    libncurses5 \
    lib32z1 \
    libbz2-1.0 \
    libqt5widgets5 \
    libqt5gui5 \
    libqt5network5 \
    novnc \
    websockify \
    && apt-get clean

RUN curl -sS https://dl.google.com/android/repository/${SDK_VERSION} -o /tmp/sdk.zip \
    && mkdir -p ${ANDROID_HOME}/cmdline-tools \
    && unzip -q -d ${ANDROID_HOME}/cmdline-tools /tmp/sdk.zip \
    && mv ${ANDROID_HOME}/cmdline-tools/cmdline-tools ${ANDROID_HOME}/cmdline-tools/latest \
    && rm /tmp/sdk.zip

RUN yes | sdkmanager --licenses \
    && yes | sdkmanager "platform-tools" \
        "platforms;android-${ANDROID_BUILD_VERSION}" \
        "build-tools;${ANDROID_TOOLS_VERSION}" \
        "system-images;android-${ANDROID_BUILD_VERSION};default;x86_64" \
        "emulator"

COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 5554 5037 6080

CMD ["bash", "-c", "x11vnc -create -forever -rfbport 5900 & websockify --web /usr/share/novnc/ 6080 localhost:5900 & adb -a -P 5037 server nodaemon"]