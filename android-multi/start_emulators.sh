[supervisord]
nodaemon=true

; ========================
; Emulator 1 (Display :0)
; ========================
[program:xvfb_emulator1]
command=/usr/bin/Xvfb :0 -screen 0 ${SCREEN_WIDTH}x${SCREEN_HEIGHT}x24
autostart=true
autorestart=true
stdout_logfile=/var/log/xvfb_emulator1.log
stderr_logfile=/var/log/xvfb_emulator1_err.log

[program:openbox_emulator1]
command=/usr/bin/openbox-session
environment=DISPLAY=":0"
autostart=true
autorestart=true
stdout_logfile=/var/log/openbox_emulator1.log
stderr_logfile=/var/log/openbox_emulator1_err.log
startsecs=5

[program:x11vnc_emulator1]
command=/usr/bin/x11vnc -display :0 -nopw -listen 0.0.0.0 -xkb -forever -rfbport 5900
autostart=true
autorestart=true
stdout_logfile=/var/log/x11vnc_emulator1.log
stderr_logfile=/var/log/x11vnc_emulator1_err.log

[program:android_emulator1]
command=/usr/bin/emulator -avd ${DEVICE_TYPE} -gpu swiftshader_indirect -verbose -port 5554
environment=DISPLAY=":0"
autostart=true
autorestart=true
stdout_logfile=/var/log/android_emulator1.log
stderr_logfile=/var/log/android_emulator1_err.log
startsecs=15

[program:novnc_emulator1]
command=/opt/noVNC/utils/websockify --web=/opt/noVNC 6080 localhost:5900
autostart=true
autorestart=true
stdout_logfile=/var/log/novnc_emulator1.log
stderr_logfile=/var/log/novnc_emulator1_err.log

; ========================
; Emulator 2 (Display :1)
; ========================
[program:xvfb_emulator2]
command=/usr/bin/Xvfb :1 -screen 0 ${SCREEN_WIDTH}x${SCREEN_HEIGHT}x24
autostart=true
autorestart=true
stdout_logfile=/var/log/xvfb_emulator2.log
stderr_logfile=/var/log/xvfb_emulator2_err.log

[program:openbox_emulator2]
command=/usr/bin/openbox-session
environment=DISPLAY=":1"
autostart=true
autorestart=true
stdout_logfile=/var/log/openbox_emulator2.log
stderr_logfile=/var/log/openbox_emulator2_err.log
startsecs=5

[program:x11vnc_emulator2]
command=/usr/bin/x11vnc -display :1 -nopw -listen 0.0.0.0 -xkb -forever -rfbport 5901
autostart=true
autorestart=true
stdout_logfile=/var/log/x11vnc_emulator2.log
stderr_logfile=/var/log/x11vnc_emulator2_err.log

[program:android_emulator2]
command=/usr/bin/emulator -avd emulator2 -gpu swiftshader_indirect -verbose -port 5564
environment=DISPLAY=":1"
autostart=true
autorestart=true
stdout_logfile=/var/log/android_emulator2.log
stderr_logfile=/var/log/android_emulator2_err.log
startsecs=15

[program:novnc_emulator2]
command=/opt/noVNC/utils/websockify --web=/opt/noVNC 6081 localhost:5901
autostart=true
autorestart=true
stdout_logfile=/var/log/novnc_emulator2.log
stderr_logfile=/var/log/novnc_emulator2_err.log
