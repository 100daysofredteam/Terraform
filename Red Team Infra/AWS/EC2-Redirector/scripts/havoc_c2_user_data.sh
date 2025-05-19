#!/bin/bash

# Installing git and curl (in case they are not available)
sudo apt install -y git
echo  '[+] Installed git' > /home/ubuntu/log.txt
sudo apt install -y curl
echo  '[+] Installed curl' >> /home/ubuntu/log.txt
sudo apt install -y net-tools openssl
echo  '[+] Installed net-tools and openssl' >> /home/ubuntu/log.txt

# Saving private key to the instance
cd /home/ubuntu
echo  '[+] In /home/ubuntu directory' >> /home/ubuntu/log.txt
echo "${private_key_b64}" | base64 -d > /home/ubuntu/100daysofredteam-key.pem

sudo chmod 600 /home/ubuntu/100daysofredteam-key.pem
sudo chown ubuntu:ubuntu /home/ubuntu/100daysofredteam-key.pem

echo  '[+] Saved private key' >> /home/ubuntu/log.txt


# Building Havoc C2 server

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


# Creating systemd service to auto start Havoc C2

# Create a systemd service for Havoc C2
cat <<EOF | sudo tee /etc/systemd/system/havoc-c2.service > /dev/null
[Unit]
Description=Havoc C2 Teamserver Service
After=network.target
Wants=network.target

[Service]
Type=Simple
WorkingDirectory=/home/ubuntu/Havoc
ExecStart=/home/ubuntu/Havoc/havoc server --profile /home/ubuntu/Havoc/profiles/havoc.yaotl


[Install]
WantedBy=multi-user.target
EOF

echo  '[+] Created systemd service for Havoc C2' >> /home/ubuntu/log.txt

# Reload systemd to recognize the new service
sudo systemctl daemon-reload

# Enable Havoc C2 to start on boot
sudo systemctl enable havoc-c2

# Start the Havoc C2 service now
sudo systemctl start havoc-c2

echo  '[+] Enabled and started Havoc C2 service' >> /home/ubuntu/log.txt

# Installing and enabling autossh

ssh-keyscan -H ${redirector_private_ip} >> /home/ubuntu/.ssh/known_hosts

sudo apt-get install -y autossh

echo  '[+] Installed autossh' >> /home/ubuntu/log.txt

# Write SSH config
cat <<EOF > /home/ubuntu/.ssh/config
Host redirector-1
    HostName ${redirector_private_ip}
    User ubuntu
    Port 22
    IdentityFile /home/ubuntu/100daysofredteam-key.pem
    RemoteForward 8443 localhost:443
    ServerAliveInterval 30
    ServerAliveCountMax 3
EOF

chown ubuntu:ubuntu /home/ubuntu/.ssh/config
chmod 600 /home/ubuntu/.ssh/config

echo  '[+] Created autossh config file' >> /home/ubuntu/log.txt

# Create autossh systemd service
cat <<EOF | sudo tee /etc/systemd/system/autossh-redirector.service
[Unit]
Description=AutoSSH tunnel to redirector-1
After=network.target
Wants=network.target

[Service]
User=ubuntu
Type=Simple
ExecStart=/usr/bin/autossh -M 0 -N -F /home/ubuntu/.ssh/config redirector-1
Restart=on-failure
[Install]
WantedBy=multi-user.target
EOF

echo  '[+] Created autossh systemd service' >> /home/ubuntu/log.txt

# Enable and start the service
sudo systemctl daemon-reload
sudo systemctl enable autossh-redirector.service
sudo systemctl start autossh-redirector.service

echo  '[+] Enabled and started autossh systemd service' >> /home/ubuntu/log.txt

