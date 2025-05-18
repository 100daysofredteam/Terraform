#!/bin/bash
cd /tmp
wget http://http.kali.org/kali/pool/main/k/kali-archive-keyring/kali-archive-keyring_2025.1_all.deb
sudo dpkg -i kali-archive-keyring_2025.1_all.deb
sudo apt update 
echo  '[+] Ran apt update' > /home/kali/log.txt
# Installing debconf-utils to allow for non-interactive installations
sudo apt install -y debconf-utils
echo  '[+] Installed debconf-utils' >> /home/kali/log.txt
# sudo DEBIAN_FRONTEND=noninteractive apt install -y kali-linux-headless   # Uncomment this line to install Kali tools. This will take time

# Enabling RDP. This is required to be able to execute Havoc C2 GUI
sudo DEBIAN_FRONTEND=noninteractive apt install -y xrdp xfce4 xfce4-goodies
echo "startxfce4" > ~/.xsession
sudo systemctl enable xrdp
sudo systemctl restart xrdp 
echo "kali:${kali_password}" | sudo chpasswd
echo  '[+] Enabled RDP' >> /home/kali/log.txt


# Saving private key to the instance
cd /home/kali
echo  '[+] In /home/kali directory' >> /home/kali/log.txt
echo "${private_key_b64}" | base64 -d > /home/kali/100daysofredteam-key.pem

sudo chmod 600 /home/kali/100daysofredteam-key.pem
sudo chown kali:kali /home/kali/100daysofredteam-key.pem

echo  '[+] Saved private key' >> /home/kali/log.txt

# Installing git and curl (in case they are not available)
sudo apt install -y git
echo  '[+] Installed git' >> /home/kali/log.txt
sudo apt install -y curl
echo  '[+] Installed curl' >> /home/kali/log.txt

# Building Havoc C2 client
cd /home/kali/
echo  '[+] In /home/kali directory' >> /home/kali/log.txt
git clone https://github.com/HavocFramework/Havoc.git
echo  '[+] Downloaded Havoc C2' >> /home/kali/log.txt
cd Havoc
echo  '[+] In Havoc directory' >> /home/kali/log.txt
sudo add-apt-repository ppa:deadsnakes/ppa >> /home/kali/log.txt
echo  '[+] Added deadsnakes repository' >> /home/kali/log.txt
sudo apt update
sudo apt install -y python3.10 python3.10-dev  >> /home/kali/log.txt
echo  '[+] Installed Python' >> /home/kali/log.txt
sudo DEBIAN_FRONTEND=noninteractive apt install -y build-essential apt-utils cmake libfontconfig1 libglu1-mesa-dev libgtest-dev libspdlog-dev libboost-all-dev libncurses5-dev libgdbm-dev libssl-dev libreadline-dev libffi-dev libsqlite3-dev libbz2-dev mesa-common-dev qtbase5-dev qtchooser qt5-qmake qtbase5-dev-tools libqt5websockets5 libqt5websockets5-dev qtdeclarative5-dev golang-go qtbase5-dev libqt5websockets5-dev python3-dev libboost-all-dev mingw-w64 nasm
echo  '[+] Installed Havoc C2 dependencies' >> /home/kali/log.txt
sudo make client-build
echo  '[+] Built Havoc C2 client' >> /home/kali/log.txt