#!/usr/bin/env bash

# From rus Ubuntu server with package:
#  openssh samab print-server

# Definition

sudo apt update -y  && sudo apt upgrade -y

sudo apt install -y lxde vim cups tigervnc-scraping-server

# Setting VNC server
mkdir -p ~/.vnc

vncpasswd passwd

ufw allow 5901:5910/tcp

x0vncserver -passwordfile ~/.vnc/passwd -display :0 >/dev/null 2>&1 &

apt-get install git psmisc
git clone https://github.com/sebestyenistvan/runvncserver
cp ~/runvncserver/startvnc ~
chmod +x ~/startvnc
echo "/home/user/startvnc start >/dev/null 2>&1" >> ~/.xsessionrc
#VNC сервер не запустится пока пользваоель локально не войдет в систему
