#!/bin/bash

echo micro-ROS agent cross-compailing for Raspberry-Pi 3


sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
apt-key adv --keyserver hkp://pool.sks-keyservers.net --recv-key 0xB01FA116
apt-get update
apt install wget git python3-vcstool

python3 -m pip install -U pyparted 

mkdir -p cc_ws/micro-ros_rpi/agent_ws/src #Agent ws
cd cc_ws/micro-ros_rpi

echo Downloading tools for cross-compilation
git clone https://github.com/micro-ROS/polly
git clone https://github.com/micro-ROS/ros2_raspbian_tools

cd ~/cc_ws/micro-ros_rpi/ros2_raspbian_tools
cat Dockerfile.bootstrap | docker build -t ros2-raspbian:crosscompiler -
./convert_raspbian_docker.py ros2-raspbian

