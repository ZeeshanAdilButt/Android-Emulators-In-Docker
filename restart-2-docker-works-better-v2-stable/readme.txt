


docker run -d --privileged -p 6080:6080 -p 5554:5554 -p 5555:5555 -e EMULATOR_DEVICE="Nexus 4" --device /dev/kvm   --name android_emulator_initial budtmo/docker-android:emulator_9.0

-- copy mismatches with the volume mount

docker cp android_emulator_initial:/home/androidusr/.android C:\docker\android


docker cp android_emulator_initial:/home/androidusr/emulator C:\docker\android\emulator


++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 single  line command


#restart all containers
docker restart $(docker ps -a -q)


Stop all containers:

docker stop $(docker ps -q)
docker rm $(docker ps -a -q)

#run idempotent containers with volume
docker run --privileged --restart always -d -p 6080:6080 -p 5555:5555 -e EMULATOR_DEVICE="Nexus 4" -e HOST=localhost -e WEB_VNC=true --device /dev/kvm --name android_emulator zee-docker-android-persist

#run idempotent containers with volume --> depend upon the copied emulator and avd files from the android_emulator_initial 
docker run --privileged -d -p 6080:6080 -p 5555:5555 -e EMULATOR_DEVICE="Nexus 4" -e EMULATOR_ARGS="-partition-size 2048" -e HOST=localhost -e WEB_VNC=true --device /dev/kvm -v C:\docker\android\android\avd:/home/androidusr/.android/avd -v C:\docker\android\emulator:/home/androidusr/emulator --name android_emulator custom-android-emulator


# some improvements:

$memoryLimit = "2560m"    # 500 MB
$cpuLimit = "1.0"        # 1 CPU
$memoryswap= "10240m"

+++++++++++++++++++++++++++++++++++++++++++++++++++++++


#fresh start
docker stop $(docker ps -q)
docker rm $(docker ps -a -q)


some quick paths:

cd /opt
cd /opt/docker-android




cd /opt/docker-android

mkdir docker
cd docker
rm dockerfile
touch dockerfile
chmod +x dockerfile
vi dockerfile

rm run.sh
touch run.sh
chmod +x run.sh
vi run.sh

mkdir /opt/docker-android/device-0-android-cluster
ls -la /opt/docker-android/device-0-android-cluster

docker build -t zee-docker-android-persist .
cd ..

rm startup.sh
touch startup.sh
chmod +x startup.sh
vi startup.sh
./startup.sh 20

#soft restart script
touch soft-restart.sh
chmod +x soft-restart.sh
vi soft-restart.sh
./soft-restart.sh 8,26,31,29,27,20,21


#cleanup script
cd docker-android
rm cleanup.sh
touch cleanup.sh
chmod +x cleanup.sh
vi cleanup.sh

#restart script
cd docker-android
rm restart.sh
touch restart.sh
chmod +x restart.sh
vi restart.sh

 
+++++++++++++++++++++++++++++++++++++++++++++++

stats and execution

docker stats device-0-android-cluster

docker exec -it device-0-android-cluster bash

cat /sys/fs/cgroup/memory/memory.limit_in_bytes

docker inspect device-0-android-cluster | grep -i -E "Memory|MemorySwap"

+++++++++++++++++++++++++++++++++++++++++++++++

Testing with adb:

adb devices

adb connect localhost:5555

adb connect ${IPAddress}:5555

adb -s localhost:5555 shell input text "YourTextHere"

scrcpy -s 91.120.155.242:5555
