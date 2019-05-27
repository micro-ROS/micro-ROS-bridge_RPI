#bin/bash

WORK_DIR=$PWD

echo Installing dependencies for the host PC.

apt-get update

apt-get install libparted\
		python3 \
		python3-dev \
		python3-pip \
		qemu \
		binfmt-support \
	 	qemu-user-static

python3 -m pip install pyparted \
			vcstool

set -e
echo Starting Cross-Compilation process.


if [ $1 = "agent" ]
then
	echo Cross-Compilation Agent

	mkdir $WORK_DIR/micro-ROS-Agent_CC

	cd $WORK_DIR/micro-ROS-Agent_CC

	wget https://raw.githubusercontent.com/micro-ROS/micro-ROS-bridge_RPI/feature/docker/micro-ROS-Agent_Cross-Compilation/Dockerfile

	docker build -t ros2-crosscompiler:latest - < Dockerfile

	docker run -it --name ros2_cc \
	    -v /var/run/docker.sock:/var/run/docker.sock \
	    -v $(pwd):/root/cc_ws \
	    --cap-add SYS_ADMIN \
	    --privileged \
	    ros2-crosscompiler:latest

elif [ $1 = "client" ]
then
	echo Cross-Compilation Client

	mkdir $WORK_DIR/micro-ROS-Client_CC

	cd $WORK_DIR/micro-ROS-Client_CC

	wget https://raw.githubusercontent.com/micro-ROS/micro-ROS-bridge_RPI/feature/docker/micro-ROS-Client_Cross-Compilation/Dockerfile

	docker build -t ros2-crosscompiler:latest - < Dockerfile

	docker run -it --name ros2_cc \
	    -v /var/run/docker.sock:/var/run/docker.sock \
	    -v $(pwd):/root/cc_ws \
	    --cap-add SYS_ADMIN \
	    --privileged \
	    ros2-crosscompiler:latest

elif [ $1 = "ros2"]
then
	echo Cross-Compilation ROS2

	mkdir $WORK_DIR/ROS2_CC

	cd $WORK_DIR/ROS2_CC

	wget https://raw.githubusercontent.com/micro-ROS/micro-ROS-bridge_RPI/feature/docker/ROS2_Cross-Compilation/Dockerfile

	docker build -t ros2-crosscompiler:latest - < Dockerfile

	docker run -it --name ros2_cc \
	    -v /var/run/docker.sock:/var/run/docker.sock \
	    -v $(pwd):/root/cc_ws \
	    --cap-add SYS_ADMIN \
	    --privileged \
	    ros2-crosscompiler:latest

else
 echo Error
fi

cd micro-ros_rpi/ros2_raspbian_tools

echo Adding ROS2 dependencies to the Raspbian docker.

./export_raspbian_image.py ros2-raspbian:lite ros2_dependencies_crystal.bash ros2-raspbian-rootfs.tar

cd ..

mkdir rpi-root

echo Uncompressing the image.

tar -C $(pwd)/rpi-root -xvf $(pwd)/ros2_raspbian_tools/ros2-raspbian-rootfs.tar


if [ $1 = "agent" ]
then

	echo Starting building process of micro-ROS Agent.

	cd agent_ws
	wget https://raw.githubusercontent.com/microROS/micro-ROS-doc/master/repos/agent_minimum.repos -O micro_ros.repos
	vcs-import src < micro_ros.repos

	cd ..

	docker run -it --rm \
	    -v $(pwd)/polly:/polly \
	    -v $(pwd)/agent_ws:/agent_ws \
	    -v $(pwd)/ros2_raspbian_tools/build_ros2_microros.bash:/build_ros2.bash \
	    -v $(pwd)/rpi-root:/raspbian_ros2_root \
	    -w /agent_ws \
	    ros2-raspbian:crosscompiler \
	    bash /build_ros2.bash

elif [ $1 = "client" ]
then

	echo Starting building process of micro-ROS Client.

	cd client_ws
	wget https://raw.githubusercontent.com/microROS/micro-ROS-doc/master/repos/client_minimum.repos -O micro_ros.repos
	vcs-import src < micro_ros.repos

	cd ..

	docker run -it --rm \
	    -v $(pwd)/polly:/polly \
	    -v $(pwd)/agent_ws:/agent_ws \
	    -v $(pwd)/ros2_raspbian_tools/build_ros2_microros.bash:/build_ros2.bash \
	    -v $(pwd)/rpi-root:/raspbian_ros2_root \
	    -w /agent_ws \
	    ros2-raspbian:crosscompiler \
	    bash /build_ros2.bash

elif [ $1 = "ros2"]
then
	echo Cross-Compilation ROS2

else
 echo Error
fi

