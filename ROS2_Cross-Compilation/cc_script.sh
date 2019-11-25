#!/bin/bash

echo ROS2 cross-compailing for Raspberry-Pi 3


sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
apt-key del 421C365BD9FF1F717815A3895523BAEEB01FA116
apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
apt-clean

apt-get update
apt install wget git python3-vcstool

python3 -m pip install -U pyparted 

pip3 install regex

mkdir -p ~/cc_ws/micro-ros_rpi/ros2_ws/src 
cd ~/cc_ws/micro-ros_rpi

echo Downloading tools for cross-compilation
git clone https://github.com/micro-ROS/polly
git clone https://github.com/micro-ROS/ros2_raspbian_tools

cd ~/cc_ws/micro-ros_rpi/ros2_raspbian_tools
cat Dockerfile.bootstrap | docker build -t ros2-raspbian:crosscompiler -
./convert_raspbian_docker.py ros2-raspbian
