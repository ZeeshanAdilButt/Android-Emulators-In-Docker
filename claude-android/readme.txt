
docker build -t claude-android .


docker run -it -p 6080:6080 -p 6081:6081 -p 5901:5901 -p 5902:5902 -p 5037:5037 -p 5554-5557:5554-5557 claude-android

adb connect localhost:5555  # Connects to Emulator 1
adb connect localhost:5557  # Connects to Emulator 2

adb -s localhost:5555 shell getprop ro.product.model  # Will show Emulator 1's model
adb -s localhost:5557 shell getprop ro.product.model  # Will show Emulator 2's model

