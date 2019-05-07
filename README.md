# micro-ROS-bridge_RPI

The micro-ROS bridge is a tool which connects the Micro-ROS world with ROS2 world.

## Requirements:

- A Raspberry Pi 3(RPI) with Raspbian.
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
    - Script to cross-compile: This script automates the process of cross-compilation ROS2 crystal for ARMV7 architecture. This process allows us to reduce dramatically the compilation time in comparison with compile natively in the RPI.
    - Readme.md: Instructions of how to execute the script and copy to the compiled files to the RPI.
