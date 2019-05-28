# micro-ROS-bridge_RPI

The micro-ROS bridge is a tool which connects the Micro-ROS world with ROS2 world.

## Requirements:

- A Raspberry Pi 3(RPI) with Raspbian Lite.
- A micro-SD card with almost 16GB.
- USB to micro-SD adaptor.
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

### Raspbian set-up:

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
  - Power off the Raspberry Pi.
  - Extract the SD card, insert on the USB to microSD adapter and connect it to the PC.

Ubuntu will mount automatically the Raspbian file system, allowing you to access  the files.

Now everything is ready to jump to the next step.

### Required tools:

For the bridge, we need to run the next tools on the Raspberry PI:
- ROS2
- micro-ROS Agent.
- micro-ROS client.

Due to the lack of resources of the Raspberry PI the compilation of these tools on the RPI, can take several hours. So to avoid this problem we will execute a cross-compilation process on the **host PC** which will reduce the compilation dramatically from a few hours to minutes (This time could be different in each PC).

We need to download the micro-ROS-bridge_RPI repo, executing the next command:
``git clone https://github.com/micro-ROS/micro-ROS-bridge_RPI``

Go into the folder ``micro-ROS-bridge_RPI`` and we will execute the building process of each tool.

#### ROS2 cross-compilation:

Inside of the ``micro-ROS-bridge_RPI`` type ``sudo ./process_script ros2``.
This script will run automatically all the process needed to build ROS2 for ARM. When it finishes the compiled ros2_ws will be on  ``micro-ROS-bridge_RPI/Copy_to_the_RPI``.
The copy ``micro-ROS-bridge_RPI/Copy_to_the_RPI/ROS2_WS`` to ``media/boot/home/pi``


#### micro-ROS Agent

Inside of the ``micro-ROS-bridge_RPI`` type ``sudo ./process_script agent``.
This script will run automatically all the process needed to build micro-ROS Agent for ARM. When it finishes the compiled agent_ws will be on  ``micro-ROS-bridge_RPI/Copy_to_the_RPI``.
The copy ``micro-ROS-bridge_RPI/Copy_to_the_RPI/agent_ws`` to ``media/boot/home/pi``

Due to the building process is slightly different as in the instruction described for the PC version, the micro-ROS agent executable is at: ``agent_ws/install/lib/uros_agent``.

#### micro-ROS Client

Inside of the ``micro-ROS-bridge_RPI`` type ``sudo ./process_script client``.
This script will run automatically all the process needed to build micro-ROS Agent for ARM. When it finishes the compiled agent_ws will be on  ``micro-ROS-bridge_RPI/Copy_to_the_RPI``.
The copy ``micro-ROS-bridge_RPI/Copy_to_the_RPI/client_ws`` to ``media/boot/home/pi``

Due to the building process is slightly different as in the instruction described for the PC version, the micro-ROS agent executable is at: ``client_ws/install/lib/uros_client``.

### 6lowpan installation

Copy ``micro-ROS-bridge_RPI/RPI_6lowpan`` to the user folder of the RPI.
Now go to this link, and follow the instructions at the Readme file:
[6lowpan instructions](https://github.com/micro-ROS/micro-ROS-bridge_RPI/tree/master/RPI_6lowpan)

### micro-ROS bridge demo.

Once everything is set-up, you can try if runs properly by executing the next demos:

#### Agent-Client inside the RPI by UDP connection:
In this demo, we will run a micro-ROS string publisher and a micro-ROS string subscriber.

**Check if your RPI is power-on and the ethernet cable is connected.**

On the host PC, open a terminal and set an SSH connection to the RPI. Once you're inside of the RPi, the Pi folder should look like this:
```bash
pi@raspberrypi:~ $ ls
agent_ws  client_ws  ros2_ws
```

In this first terminal, we're going to run the micro-ROS Agent. Before, we're going to configure the execution environment, type the next command:
- ``. ~/agent_ws/install/./local_setup.bash``

Now execute the agent through UDP connection over the 8888 port:

- ``./agent_ws/install/lib/uros_agent/uros_agent udp 8888 ``

If everything is fine, it should return the next:
```bash

pi@raspberrypi:~ $ ./agent_ws/install/lib/uros_agent/uros_agent udp 8888
UDP agent initialization...
OK
Enter 'q' for exit

```

Now we come back to the host PC and we open another terminal in which we will run another SSH connection to the RPI.
Once we will be on the RPI, is necessary to configure the execution environment. So type the next command:
- ``. ~/client_ws/install/./local_setup.bash``

As a final step, we will run the micro-ROS String subscriber, typing the next command:
- ``./client_ws/install/lib/string_subscriber_c/string_subscriber_c ``

You should see somenthin like this:
```bash
pi@raspberrypi:~ $ ./client_ws/install/lib/string_subscriber_c/string_subscriber_c
UDP mode => ip: 127.0.0.1 - port: 8888
```

From the subscriber side, is everything ready, so as a final step we're going to run the publisher.
Open another console on the host PC, connect to the RPI via SSH. Once you're inside of the RPI, configure the execution environment by executing the next command:
- ``. ~/client_ws/install/./local_setup.bash``

Finally execute the string publisher by typing the next command:
- ``./client_ws/install/lib/string_publisher_c/string_publisher_c ``

Once you execute the publisher, you should see the next things on the differents consoles:
- Agent console:
```bash
./agent_ws/install/lib/uros_agent/uros_agent udp 8888
UDP agent initialization...
OK
Enter 'q' for exit
RTPS Participant matched 1.f.1.ad.9e.b.0.0.1.0.0.0|0.0.1.c1
RTPS Participant matched 1.f.1.ad.9e.b.0.0.0.0.0.0|0.0.1.c1
RTPS Subscriber matched 1.f.1.ad.9e.b.0.0.0.0.0.0|0.0.1.4
RTPS Publisher matched 1.f.1.ad.9e.b.0.0.1.0.0.0|0.0.1.3
```
This show state of the DDS network from the agent to the client.

- Client Subscriber console:
```bash
I heard: [Hello World 8840]
I heard: [Hello World 8841]
I heard: [Hello World 8842]
I heard: [Hello World 8843]
I heard: [Hello World 8844]
I heard: [Hello World 8845]
I heard: [Hello World 8846]
I heard: [Hello World 8847]
I heard: [Hello World 8848]
I heard: [Hello World 8849]
I heard: [Hello World 8850]
I heard: [Hello World 8851]
I heard: [Hello World 8852]
I heard: [Hello World 8853]
I heard: [Hello World 8854]
I heard: [Hello World 8855]
I heard: [Hello World 8856]
I heard: [Hello World 8857]
I heard: [Hello World 8858]
I heard: [Hello World 8859]
I heard: [Hello World 8860]
```

This catch the published topic and show it.

- Client Publisher console:
```bash
Sending: 'Hello World 103672'
Sending: 'Hello World 103673'
Sending: 'Hello World 103674'
Sending: 'Hello World 103675'
Sending: 'Hello World 103676'
Sending: 'Hello World 103677'
Sending: 'Hello World 103678'
Sending: 'Hello World 103679'
Sending: 'Hello World 103680'
Sending: 'Hello World 103681'
Sending: 'Hello World 103682'
Sending: 'Hello World 103683'
Sending: 'Hello World 103684'
Sending: 'Hello World 103685'
Sending: 'Hello World 103686'
Sending: 'Hello World 103687'
```
This client Hello World + a number. The numbers between the publisher and the subscriber might be different because sending process is without any delay.
