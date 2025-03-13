# Use your base image (budtmo/docker-android:base_...)
ARG DOCKER_ANDROID_VERSION
FROM budtmo/docker-android:emulator_9.0

#==================
# Android Packages
#==================
ARG EMULATOR_ANDROID_VERSION
ARG EMULATOR_API_LEVEL
ENV EMULATOR_ANDROID_VERSION=${EMULATOR_ANDROID_VERSION} \
    EMULATOR_API_LEVEL=${EMULATOR_API_LEVEL} \
    EMULATOR_SYS_IMG=x86_64 \
    EMULATOR_IMG_TYPE=google_apis \
    EMULATOR_BROWSER=chrome
ENV PATH ${PATH}:${ANDROID_HOME}/build-tools
RUN yes | sdkmanager --licenses \
 && sdkmanager "platforms;android-${EMULATOR_API_LEVEL}" \
    "system-images;android-${EMULATOR_API_LEVEL};${EMULATOR_IMG_TYPE};${EMULATOR_SYS_IMG}" "emulator" \
 && ln -s ${ANDROID_HOME}/emulator/emulator /usr/bin/

#=============#
# UI Packages #
#-------------#
RUN apt-get -qqy update && apt-get -qqy install --no-install-recommends \
    ffmpeg \
    feh \
    libxcomposite-dev \
    menu \
    openbox \
    x11vnc \
    xterm \
 && apt autoremove -y \
 && apt clean all \
 && rm -rf /var/lib/apt/lists/*

#=======#
# noVNC  #
#=======#
ENV NOVNC_VERSION="1.4.0" \
    WEBSOCKIFY_VERSION="0.11.0" \
    OPT_PATH="/opt"
RUN  wget -nv -O noVNC.zip "https://github.com/novnc/noVNC/archive/refs/tags/v${NOVNC_VERSION}.zip" \
 && unzip -x noVNC.zip \
 && rm noVNC.zip  \
 && mv noVNC-${NOVNC_VERSION} ${OPT_PATH}/noVNC \
 && wget -nv -O websockify.zip "https://github.com/novnc/websockify/archive/refs/tags/v${WEBSOCKIFY_VERSION}.zip" \
 && unzip -x websockify.zip \
 && mv websockify-${WEBSOCKIFY_VERSION} ${OPT_PATH}/noVNC/utils/websockify \
 && rm websockify.zip \
 && ln ${OPT_PATH}/noVNC/vnc.html ${OPT_PATH}/noVNC/index.html

#===============#
# Default Display #
#===============#
ENV DISPLAY=:0 \
    SCREEN_NUMBER=0 \
    SCREEN_WIDTH=1600 \
    SCREEN_HEIGHT=900 \
    SCREEN_DEPTH=24+32 \
    VNC_PORT=5900 \
    WEB_VNC_PORT=6080

# Expose the ports for emulator1
EXPOSE 5554 5555 5900 6080

# Expose additional ports for emulator2 (we will use display :1)
EXPOSE 5564 5565 5901 6081

#==========#
# Copy app #
#==========#
RUN rm -rf ${SCRIPT_PATH}
ENV SCRIPT_PATH="docker-android"
ENV WORK_PATH="/home/androidusr"
ENV APP_PATH=${WORK_PATH}/${SCRIPT_PATH}
RUN mkdir -p ${APP_PATH}
COPY mixins ${APP_PATH}/mixins
COPY cli ${APP_PATH}/cli
RUN chown -R 1300:1301 ${APP_PATH} \
 && pip install --quiet -e ${APP_PATH}/cli

#====================#
# Configure OpenBox  #
#====================#
RUN echo ${APP_PATH}/mixins/configs/display/.fehbg >> /etc/xdg/openbox/autostart

#====================#
# Create Second AVD  #
#====================#
# Switch temporarily to root to create a new AVD.
USER root
RUN echo "no" | avdmanager create avd -n emulator2 -k "system-images;android-${EMULATOR_API_LEVEL};${EMULATOR_IMG_TYPE};${EMULATOR_SYS_IMG}" --force
# Switch back to the created user.
USER 1300:1301

#====================#
# Use created user   #
#====================#
ENV LOG_PATH=${WORK_PATH}/logs \
    WEB_LOG_PORT=9000
EXPOSE 9000
RUN mkdir -p ${LOG_PATH}
RUN mkdir -p "${WORK_PATH}/.config/Android Open Source Project" \
 && echo "[General]\nshowNestedWarning=false\n" > "${WORK_PATH}/.config/Android Open Source Project/Emulator.conf"

#==========================#
# Copy Custom Supervisor   #
#==========================#
# This supervisor configuration will run two sets of processes,
# one for each emulator instance.
# Place the file "supervisord.conf" in the same directory as this Dockerfile.
USER root
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

#=========#
# Run App #
#=========#
STOPSIGNAL SIGTERM
ENV DEVICE_TYPE=emulator
ENTRYPOINT ["/home/androidusr/docker-android/mixins/scripts/run.sh"]
