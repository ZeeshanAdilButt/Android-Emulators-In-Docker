# alias rm='rm -i'
# alias cp='cp -i'
# alias mv='mv -i'

# mkdir -p /opt/docker-android/docker && chmod -R 777 /opt/docker-android/docker && for i in {0..39}; do mkdir -p "/opt/docker-android/device-${i}-android-cluster" && chmod -R 777 "/opt/docker-android/device-${i}-android-cluster"; done

# Update package index
sudo apt-get update

#neccessary packages
sudo apt install htop nmon glances nethogs iftop


Swap size of 200gb

# Check current swap configuration
sudo swapon --show

# Turn off any existing swap
sudo swapoff -a

# Create a 100GB swap file
sudo fallocate -l 100G /swapfile
# Alternative if fallocate doesn't work:
# sudo dd if=/dev/zero of=/swapfile bs=1G count=100

# Set correct permissions
sudo chmod 600 /swapfile

# Format as swap
sudo mkswap /swapfile

# Enable the swap
sudo swapon /swapfile

# Make it permanent (add to fstab)
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab


#install docker


# Install dependencies
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

# Add Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Set up the stable repository
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Update package index again
sudo apt-get update

# Install Docker CE
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# Start and enable Docker
sudo systemctl start docker
sudo systemctl enable docker

# Verify installation
sudo docker run hello-world

#fresh start
#remove all containers
docker stop $(docker ps -q)
docker rm $(docker ps -a -q)

# move to the opt path
cd /opt

# Create the docker-android directory
mkdir docker-android

# Verify the directory has been created
ls

# move to docker android folder
cd /opt/docker-android

#created docker directory and move to it
mkdir docker
cd docker

# remove any existing docker file and create new one with permission and paste the correct docker file
rm dockerfile
touch dockerfile
chmod +x dockerfile
vi dockerfile

## remove any existing run file and create new one with permission and paste the correct run file needed by docker file
rm run.sh
touch run.sh
chmod +x run.sh
vi run.sh

# build the image to be used by docker container
docker build -t zee-docker-android-persist .
cd ..

# remove any existing startup file and create new one with permission and paste the correct staartup file
rm startup.sh
touch startup.sh
chmod +x startup.sh
vi startup.sh


# remove any existing soft-restart file and create new one with permission and paste the correct soft-restart file -- used to restart the container without removing them
touch soft-restart.sh
chmod +x soft-restart.sh
vi soft-restart.sh

# make a danger directory that contains script to clean up and restart containers after removing
mkdir danger
cd danger


# remove any existing cleanup file and create new one with permission and paste the correct cleanup file
rm cleanup.sh
touch cleanup.sh
chmod +x cleanup.sh
vi cleanup.sh

# remove any existing cleanup file and restart (hard) new one with permission and paste the correct restart (hard) file
rm restart.sh
touch restart.sh
chmod +x restart.sh
vi restart.sh

cd ..
# back from danger in the docker-android directory so you can run the related commands


++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

#scripts
#fresh start
#remove all containers
docker stop $(docker ps -q)
docker rm $(docker ps -a -q)
./startup.sh 30

# move to docker android folder
cd /opt/docker-android

#initial start
./startup.sh 25

#connect adb on upto 40 devices  - not all machines run 40 devices so it will connect to first x devices which were run as per above script
for i in {5555..5594}; do adb connect localhost:$i; done

adb devices


# soft restart devices only if needed
./soft-restart.sh 8,26,31,29,27,20,21


# DANGER

# recreate devices
./cleanup.sh 8,26,31,29,27,20,21
./restart.sh 8,26,31,29,27,20,21