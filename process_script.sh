#bin/bash

apt-get install lipbarted \
		python3 \
		python3-dev \
		python3-pip \
		qemu \
		binfmt-support \
	 	qemu-user-static

python3 -m pip install pyparted \
			vcstool


mkdir $(pwd)/micro-ROS-Agent_CC

cd $(pwd)/micro-ROS-Agent_CC

wget https://raw.githubusercontent.com/micro-ROS/micro-ROS-bridge_RPI/feature/docker/Dockerfile

docker build -t ros2-crosscompiler:latest - < Dockerfile

docker run -it --name ros2_cc \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v $(pwd):/root/cc_ws \
    --cap-add SYS_ADMIN \
    --privileged \
    ros2-crosscompiler:latest

cd micro-ros_rpi/ros2_raspbian_tools

./export_raspbian_image.py ros2-raspbian:crosscompiler ros2_dependencies_crystal.bash ros2-raspbian-rootfs.tar

cd ..

mkdir rpi-root

tar -C $(pwd)/rpi-root -xvf $(pwd)/ros2_raspbian_tools/ros2-raspbian-rootfs.tar

cd agent_ws
wget https://raw.githubusercontent.com/microROS/micro-ROS-doc/master/repos/agent_minimum.repos -O micro_ros.repos
vcs-import src < micro_ros.repos

docker run -it --rm \
    -v $(pwd)/polly:/polly \
    -v $(pwd)/agent_ws:/agent_ws \
    -v $(pwd)/ros2_raspbian_tools/build_ros2_microros.bash:/build_ros2.bash \
    -v $(pwd)/rpi-root:/raspbian_ros2_root \
    -w /agent_ws \
    ros2-raspbian:crosscompiler \
    bash /build_ros2.bash

