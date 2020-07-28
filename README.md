# micro-ROS-bridge_RPI

The micro-ROS bridge is a tool that connects the Micro-ROS world with the ROS2 world. On this repository, you will find the list of requirements and the steps to set-up properly this tool.

## Requirements:

- A Raspberry Pi 3(RPI) with Raspbian Lite.
- A micro-SD card with almost 16GB of memory.
- USB to micro-SD adaptor.
- A PMODRF2 Radio module which are base on the MRF24J40 chip.
- A PC x86/x64 running Ubuntu (The tests have been performed in Ubuntu 18.04).
- Docker in our PC. [(How to install Docker)](https://docs.docker.com/install/linux/docker-ce/ubuntu/)

## Instructions:

On the next instructions we will follow the next instructions to achieve a fully functional micro-ROS hardware bridge:

- Raspbian Installation and Set-Up.
- 6LoWPAN radio installation.
- Add micro-ROS hardware bridge suite.
- Configure micro-ROS Hardware bridge software.
- How to use micro-ROS Hardware bridge.
  - Add a new 6LoWPAN end-point device.
  - Execute Micro-ROS Agent.

### Raspbian Installation and Set-Up

The default select O.S. is Raspbian thanks to the important support from the Raspberry foundation and the total implementation of all the required communication protocols.

First, we need to download Raspbian. Any version of this operating system is valid, but we recommend the Lite version due to is lighter and this tutorial is focused on this version.
You can find here: [Download Raspbian Lite](https://downloads.raspberrypi.org/raspbian_lite_latest)

Once you've downloaded Raspbian you need to flash to SD card with the operating system. The Raspberry Pi Foundation offers an explanatory guide of how to proceed, you can find on the next link: [Raspbian Lite installation guide](https://www.raspberrypi.org/documentation/installation/installing-images/README.md)

Once is installed, we need to prepare a headless set-up. This means that you're going to work with the RPi over SSH connection. There is available a guide which explains how to use a headless implementation, and you can find here:[Raspberry Pi Headless Tutorial](https://www.raspberrypi.org/documentation/configuration/wireless/headless.md)

It doesn't matter if you decide to use via Ethernet or Wi-Fi, the result will be the same. Once everything is ready, you need to open a terminal on your host PC and connect to the RPi, using the next command:
```
ssh pi@<RaspberryPi-IP>
```

When you're connected to the RPi, is necessary to expanse the file system, to do so, execute the next command on the RPi console:
```
sudo raspi-config
```

On the menu that will appear, go to:
- Advance Options -> Expand File System and push yes.

Now just finish to turn off the RPi, by typing the next command on the console:
```
sudo poweroff
```

### 6LoWPAN radio installation

Before proceeding, be sure that your RPi is disconnected from the power supply because is not recommendable to manipulate the GPIO pins with power supply.

The radio that we're going to use is [PModRF2-MRF24J40](https://store.digilentinc.com/pmod-rf2-ieee-802-15-rf-transceiver/), this radio work via SPI and is base on the Microchip chip [MRF24J40](https://www.microchip.com/wwwproducts/en/en027752).

To connect the radio to the RPI, we need to do the wiring connetions:

|  | RPI | PMODRF2 |
| -- | -- | -- |
| VIN | 1 | 12 |
| GND | 20 | 11 |
| RESET | 17 | 8 |
| INT | 16 | 7 |
| SDI | 19 | 2 |
| SDO | 21 | 3 |
| SCK | 23 | 4 |
| CS | 26 | 1 |

On the next links you can find the pinout of the RPI 3 and the radio module, which will help you to the wiring process:

- [Raspberry Pi 3 pinout.](https://i.pinimg.com/originals/84/46/ec/8446eca5728ebbfa85882e8e16af8507.png)
- [PMODRF2 pionut.](https://reference.digilentinc.com/reference/pmod/pmodrf2/start)

### Add Micro-ROS Hardware Bridge Suite

First, you need to obtain the required software. To do so, you need to go to the [Micro-ROS Build System](https://github.com/micro-ROS/micro-ros-build) and follow the instructions.
If everything goes fine, the Micro-ROS build system should return a folder called ``Micro-ROS-Bridge``.

Now we need to copy the Micro-ROS-Bridge folder to the Raspberry Pi, to do so follow the next steps:
- Turn On the RPI.
- Go to the main folder of the Micro-ROS build system.
- Open a terminal.
- Be sure that your RPI has an internet connection. (Tip: You can do a ping to the RPI, typing on the console ``ping <raspbery_pi_ip>)
- On the console we will use ssh to copy the files, you need type the next command:
```
scp -r Micro-ROS-Bridge  pi@1<raspberry_pi_ip>:/home/pi
```

This method can be slower than simply copy to the SD card, but this warranty us that the integrity of the files is correct.

Now the RPI includes all the necessary software.

### Configure micro-ROS Hardware bridge software

Open a terminal and connect to the RPI via SSH.
If everything goes fine, if you type on console ``ls`` it should return a folder called ``Micro-ROS-Bridge``. Type the next commands:

- Go to the folder: ``cd Micro-ROS-Bridge``
- Execute the Micro-ROS Bridge utility by typing: ``./micro-ROS-HB.sh``.
- If this is a clean installation, it will detect that 6LoWPAN stack and the radio are not configured, so it will ask if you want to configure it.
  - If you type **y**, it will start the installation process. Once is finished it will ask you for a reboot.
  - After reboot, the radio should be ready, but to be sure type the next command:
  ```
  dmesg | grep mrf24j40
  ```
  - If returns ``[    5.332990] mrf24j40 spi0.0: probe(). IRQ: 166``, everything goes fine.

Now the Micro-ROS hardware bridge is ready to work. On the next points, we will explain how to use it.

### How to use micro-ROS Hardware bridge

At this point, everything is ready to work, this is a guide of how to use the Micro-ROS Hardware Bridge utility. This tool gives you an intuitive menu which makes you easy the usage of the bridge.

#### Add a new 6LoWPAN endpoint device

Before using the 6LoWPAN communications, we need to add the device which we will establish communications. To do so, follow the next steps:

- On the RPI got the Micro-ROS-Bridge folder: ``cd Micro-ROS-Bridge``
- Execute the utility by typing the next command: ``./micro-ROS-HB.sh``
- Once is ready it should return a menu like this:
```
1) Add new 6LoWPAN micro-ROS device      3) Create UDP micro-ROS Agent            5) Create Serial micro-ROS Agent server
2) Create UDP 6LoWPAN micro-ROS Agent    4) Create TCP micro-ROS Agent            6) Quit
#?
```
- Type ``1`` plus enter to add a new device.
- Introduce the IPV6 of your endpoint device.
- Introduce the MAC direction of your device.

Now your device is ready to receive communications over 6LowPAN from another radio device.

#### Execute Micro-ROS Agent.

At this moment this utility allows the next kind of connections:
- UDP IPV6 for 6LoWPAN.
- UDP IPV4 for ethernet and Wi-FI.
- TCP IPV4 for ethernet and Wi-FI. 
- Serial connections.

On the menu you can see the different available options, is just necessary to introduce the number of the option and **write the port number that we want to use** if we're using UDPV6, UDP or TCP or **write the direction of the serial device** that you want to use.

This utility allows you to open various Micro-ROS Agents at the same time if you want to use different communications protocols.

Finally, this is a work in progress point, but we have option number 6 to close the utility, but at this moment is recommendable to use the command "CTRL + C" to send the kill signal. This will close automatically all the Agents already open.


## Purpose of the Project

This software is not ready for production use. It has neither been developed nor
tested for a specific use case. However, the license conditions of the
applicable Open Source licenses allow you to adapt the software to your needs.
Before using it in a safety relevant setting, make sure that the software
fulfills your requirements and adjust it according to any applicable safety
standards, e.g., ISO 26262.

## License

micro-ROS bridge for Raspberry Pi are open-sourced under the Apache-2.0 license. See the
[LICENSE](LICENSE) file for details.

For a list of other open-source components included in ROS 2 system_modes,
see the file [3rd-party-licenses.txt](3rd-party-licenses.txt).

## Known Issues/Limitations

There is no known limitations