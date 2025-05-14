#!/bin/bash
cd /tmp
wget http://http.kali.org/kali/pool/main/k/kali-archive-keyring/kali-archive-keyring_2025.1_all.deb
sudo dpkg -i kali-archive-keyring_2025.1_all.deb
sudo apt update && sudo apt install -y kali-linux-headless