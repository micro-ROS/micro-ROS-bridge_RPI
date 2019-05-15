# micro-ROS-bridge_RPI

The micro-ROS bridge is a tool which connects the Micro-ROS world with ROS2 world.

## Requirements:

- A Raspberry Pi 3(RPI) with Raspbian Lite.
- A micro-SD card with almost 16GB.
- A PC x86/x64 running Ubuntu (The tests have been performed in Ubuntu 16.04).
- Docker in our PC. [(How to install Docker)](https://docs.docker.com/install/linux/docker-ce/ubuntu/)

## Tools in this repository:

- RPI-6lowpan:
  - 6lowpan set-up script: This script will install and configure all the dependencies to use 6lowpan stack with the MRF24J40 radio in the RPI.
  - 6lowpan receive example: This is an example of how to receive data over the 6lowpan network.
  - 6lowpan send example: This is an example of how to send data over the 6lowpan network.  
  - Readme.md: Instructions to configure the network properly and how to use it.

- micro-ROS-Agent_Cross-Compilation:
  - Script to cross-compile: This script automates the process of cross-compilation micro-ROS agent for ARMV7 architecture. This process allows us to reduce dramatically the compilation time in comparison with compile natively in the RPI.
  - Readme.md: Instructions of how to execute the script and copy to the compiled files to the RPI.

- ROS2_Cross-Compilation:
    - Script to cross-compile: This script automates the process of cross-compilation ROS2 crystal and HRIM for ARMV7 architecture. This process allows us to reduce dramatically the compilation time in comparison with compile natively on the RPI.
    - Readme.md: Instructions of how to execute the script and copy to the compiled files to the RPI.

- micro-ROS-Clientt_Cross-Compilation:
  - Script to cross-compile: This script automates the process of cross-compilation micro-ROS agent for ARMV7 architecture. This process allows us to reduce dramatically the compilation time in comparison with compile natively in the RPI.
  - Readme.md: Instructions of how to execute the script and copy to the compiled files to the RPI.

## Instructions:

### Raspbian installation:

First, we need to install Raspbian Little in our RPI, you can follow the next guide to know how:
[- Download Raspbian Lite](https://downloads.raspberrypi.org/raspbian_lite_latest)
[-Raspbian Lite installation guide](https://www.raspberrypi.org/documentation/installation/installing-images/README.md)

Once Raspbian is installed on the SD, please insert on the RPI and do the next steps:
  - Execute the raspi-config menu: ``sudo raspi-config``
  - Inside the raspi-config menu, enable the serial communication:  Interfacing Options -> Serial -> Yes
  - Expand the file system: Advance Options -> Expan Filesystem.
  - Install the next dependencies:
    - ``sudo apt install python3-pip``
    - ``python3 -m pip install catkin_pkg empy lark-parser pyparsing pyyaml setuptools argcomplete``
    - ``sudo apt-get install libtinyxml2-dev``
    - ``pip3 install lxml``


Now is everything ready, the next step will be the cross-compilation of ROS2 for RPI.

### ROS2 cross-compilation:

We need to download this repo.
Once is downloaded, go to: ``micro-ROS-bridge_RPI/ROS_Cross-Compilation``.  And execute the script which is inside: ``./cc_script.sh``.
This script will execute all the tools necessary to cross-compile ROS2 and will return ROS2 Crystal for Raspbian.
(Note: Some of the commands could ask for the sudo password.)
The first time that we execute this process, could take up to 40 min (The processing time depends on the resources of each PC). When it finishes, you need to go: ``~/ros2_rpi``.
The folder ``ros2_ws`` is the ROS2 workspace, so copy this folder to the user folder of the RPI.


### micro-ROS Agent

Come back to the downloaded repo and go to: ``micro-ROS-bridge_RPI/micro-ROS-Agent_Cross-Compilation``.
And execute the script: ``./cc_script.sh``.
This script as the previous one will execute all the necessary tools to cross-compile the micro-ROS Agent returning a compiling version of micro-ROS Agent for Raspbian.
The folder ``~/micro-ros_rpi/agent_ws/ `` is the compiled version of the micro-ROS Agent for Raspbian, so as in the previous point, copy ``~/micro-ros_rpi/aget_ws/ `` to the user folder of the RPI.

Due to the building process is slightly different as in the instruction described for the PC version, the micro-ROS agent executable is at: ``agent_ws/install/lib/uros_agent``.

### micro-ROS Client

This step is optional, but if you want to execute a client from inside of the RPI, follow the next steps:
Go to: `micro-ROS-bridge_RPI/micro-ROS-Client_Cross-Compilation``.
Execute the script: ``./cc_script.sh``
Once it finished, copy the folder ``~/micro-ros_rpi/client_ws/ `` to the user folder of the RPI.

### 6lowpan installation

Copy ``micro-ROS-bridge_RPI/RPI_6lowpan`` to the user folder of the RPI.
Now go to this link, and follow the instructions at the Readme file:
[6lowpan instructions](https://github.com/micro-ROS/micro-ROS-bridge_RPI/tree/master/RPI_6lowpan)
