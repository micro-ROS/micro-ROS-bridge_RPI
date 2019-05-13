#!/bin/bash

echo micro-ROS Client cross-compailing for Raspberry-Pi 3


sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
sudo apt-key adv --keyserver hkp://pool.sks-keyservers.net --recv-key 0xB01FA116
sudo apt-get update
sudo apt install wget git python3-vcstool

mkdir -p ~/ros2_rpi/ros2_ws/src 
cd ~/ros2_rpi

echo Downloading tools for cross-compilation
git clone https://github.com/micro-ROS/polly
git clone https://github.com/micro-ROS/ros2_raspbian_tools

cd ~/ros2_rpi/ros2_raspbian_tools
cat Dockerfile.bootstrap | docker build -t ros2-raspbian:crosscompiler -
./convert_raspbian_docker.py ros2-raspbian
./export_raspbian_image.py ros2-raspbian:lite ros2_dependencies_crystal.bash ros2-raspbian-rootfs.tar


mkdir -p ~/ros2_rpi/rpi-root
cd ~/ros2_rpi/ros2_raspbian_tools
sudo tar -C ~/ros2_rpi/rpi-root -xvf ros2-raspbian-rootfs.tar

patch ~/ros2_rpi/ros2_ws/src/ros/resource_retriever/libcurl_vendor/CMakeLists.txt 

cd ..
cd ros2_ws
wget https://raw.githubusercontent.com/ros2/ros2/crystal/ros2.repos
vcs import src < ros2.repos



docker run -it --rm \
    -v ~/micro-ros_rpi/polly:/polly \
    -v ~/micro-ros_rpi/ros2_ws:/ros2_ws \
    -v ~/micro-ros_rpi/ros2_raspbian_tools/build_ros2_crystal.bash:/build_ros2.bash \
    -v ~/micro-ros_rpi/rpi-root:/raspbian_ros2_root \
    -w /ros2_ws \
    ros2-raspbian:crosscompiler \
    bash /build_ros2.bash
