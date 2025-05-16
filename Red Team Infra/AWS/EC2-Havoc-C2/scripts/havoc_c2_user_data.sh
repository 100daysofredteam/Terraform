#!/bin/bash

# Installing git and curl (in case they are not available)
sudo apt install -y git
echo  '[+] Installed git' > /home/ubuntu/log.txt
sudo apt install -y curl
echo  '[+] Installed curl' >> /home/ubuntu/log.txt

# Building Havoc C2 server
cd /home/ubuntu
echo  '[+] In /home/ubuntu directory' >> /home/ubuntu/log.txt
git clone https://github.com/HavocFramework/Havoc.git
echo  '[+] Downloaded Havoc C2' >> /home/ubuntu/log.txt
cd Havoc
echo  '[+] In Havoc directory' >> /home/ubuntu/log.txt
sudo add-apt-repository ppa:deadsnakes/ppa >> /home/ubuntu/log.txt
echo  '[+] Added deadsnakes repository' >> /home/ubuntu/log.txt
sudo apt update
echo  '[+] Ran APT update' >> /home/ubuntu/log.txt
sudo apt install -y python3.10 python3.10-dev
echo  '[+] Installed Python' >> /home/ubuntu/log.txt
sudo apt install -y build-essential apt-utils cmake libfontconfig1 libglu1-mesa-dev libgtest-dev libspdlog-dev libboost-all-dev libncurses5-dev libgdbm-dev libssl-dev libreadline-dev libffi-dev libsqlite3-dev libbz2-dev mesa-common-dev qtbase5-dev qtchooser qt5-qmake qtbase5-dev-tools libqt5websockets5 libqt5websockets5-dev qtdeclarative5-dev golang-go qtbase5-dev libqt5websockets5-dev python3-dev libboost-all-dev mingw-w64 nasm
echo  '[+] Installed dependencies' >> /home/ubuntu/log.txt
cd teamserver
echo  '[+] In teamserver directory' >> /home/ubuntu/log.txt
go mod download golang.org/x/sys
echo  '[+] Go mod sys downloaded' >> /home/ubuntu/log.txt
cd ..
echo  '[+] Back in Havoc directory' >> /home/ubuntu/log.txt
sudo make ts-build >> /home/ubuntu/log.txt
echo  '[+] Havoc C2 server built' >> /home/ubuntu/log.txt