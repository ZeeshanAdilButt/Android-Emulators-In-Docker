# Base image with long-term support
FROM ubuntu:20.04

# Install essential packages with explanations
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    openjdk-8-jdk \        
    wget \                 
    unzip \                
    xvfb \                 
    supervisor \           
    libgl1-mesa-dev \      
    libpulse-dev \         
    libasound2-dev \       
    qemu-kvm \             
    tigervnc-standalone-server \ 
    git \                  
    python3-websockify \   
    && rm -rf /var/lib/apt/lists/*

# Configure environment variables
ENV ANDROID_HOME /opt/android       
ENV NOVNC_PORT=6080                 
ENV VNC_PORT=5901                   
ENV DISPLAY=:1                      
ENV PATH="${PATH}:${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/emulator"

# Install Android Command Line Tools
RUN mkdir -p ${ANDROID_HOME}/cmdline-tools \
    && wget https://dl.google.com/android/repository/commandlinetools-linux-7302050_latest.zip -O /tmp/cmdline-tools.zip \
    && unzip /tmp/cmdline-tools.zip -d ${ANDROID_HOME}/cmdline-tools \
    && mv ${ANDROID_HOME}/cmdline-tools/cmdline-tools ${ANDROID_HOME}/cmdline-tools/latest \
    && rm /tmp/cmdline-tools.zip

# Install Android 9 (Pie) components
RUN yes | sdkmanager --licenses \
    && sdkmanager "platform-tools" "emulator" \
    && sdkmanager "platforms;android-28" \
    && sdkmanager "system-images;android-28;google_apis;x86_64"

# Create Android Virtual Devices
RUN echo "no" | avdmanager create avd -n emu1 -k "system-images;android-28;google_apis;x86_64" -d pixel \
    && echo "no" | avdmanager create avd -n emu2 -k "system-images;android-28;google_apis;x86_64" -d pixel

# Configure password-less VNC access
RUN mkdir -p /root/.vnc \
    && echo "" | vncpasswd -f > /root/.vnc/passwd \
    && chmod 600 /root/.vnc/passwd

# Set up noVNC web interface
RUN git clone https://github.com/novnc/noVNC.git /opt/noVNC \
    && git clone https://github.com/novnc/websockify /opt/noVNC/utils/websockify

# Copy Supervisor configuration
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Expose network ports
EXPOSE 6080 5037 5554-5557

# Start Supervisor as root process
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]