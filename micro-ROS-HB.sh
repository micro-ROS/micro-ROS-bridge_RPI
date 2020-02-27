#!/bin/bash

#Check if the radio is set-up
FILE=/boot/overlays/mrf24j40ma.dtbo

if [ -f "$FILE" ]; then
    RADIO_AVAILABLE="TRUE" #Radio available
    RADIO_READY="FALSE"
    
else
    #Radio and 6lowpan stack is not installed
    echo "6LoWPAN communication and the MRF24J40 is not installed."
    echo "If you don't install it, you won't have 6LoWPAN communication"
    read -n 1 -p "Do you want to install it? (Y/N): " VAR

    if [ $VAR == "y" ]; then
        #Installing MRF24J40 radio and setting up the 6lowpan stack.
        echo "Installing Dependencies\n"
        sudo apt-get update
        sudo apt install device-tree-compiler git -y

        echo "Creating device tree for MRF24J40 radio and compiling it"
#Why I can't tab this??
cat <<EOF >mrf24j40ma-overlay.dts
/dts-v1/;
/plugin/;

/ {
    compatible = "bcrm,bcm2835", "bcrm,bcm2836", "bcrm,bcm2708", "bcrm,bcm2709";

    fragment@0 {
            target = <&spi0>;
            __overlay__ {
                    #address-cells = <1>;
                    #size-cells = <0>;
                    status = "okay";

                    mrf24j40@0 {
                            compatible = "mrf24j40";
                            reg = <0>;
                            interrupts = <23 8>;
                            interrupt-parent = <&gpio>;
                            spi-max-frequency = <5000000>;
                    };

                    spidev@0 {
                            status = "disabled";
                    };

                    spidev@1 {
                            status = "disabled";
                    };
            };
    };
};
EOF
        dtc -@ -O dtb -o mrf24j40ma.dtbo mrf24j40ma-overlay.dts
        sudo cp mrf24j40ma.dtbo /boot/overlays/.

        echo "Adding MRF24J40ma to system initialization"
        sudo mv /boot/config.txt /boot/config_cpy.txt #Do a secutiry copy of the config file
        touch config.txt
        printf "dtparam=spi=on\ndtoverlay=mrf24j40ma\n" > config.txt
        sudo cp config.txt /boot #Copy the new config file
        rm config.txt

        echo "Installing WPAN tools"
        git clone https://github.com/linux-wpan/wpan-tools 
        sudo apt -y install dh-autoreconf libnl-3-dev libnl-genl-3-dev
        cd wpan-tools
        sudo ./autogen.sh
        sudo ./configure CFLAGS='-g -O0' --prefix=/usr --sysconfdir=/etc --libdir=/usr/lib
        sudo make
        sudo make install
        #The radio and the stack is ready, now is necessary to reboot
        clear
        read -n 1 -p "The Raspberry Pi will reboot now. After the reboot Micro-ROS Hardware Bridge will be ready to work, just re-open the script. Press any key to continue"
        #Configure the radio
        sudo reboot

    else
        #6LoWPAN is not available
        clean
        echo "6LoWPAN communication won't be available"
        RADIO_AVAILABLE="FALSE"
    fi
fi

#Check if the folder Lowpan exists. If it didn't exit means that the network is not up.
FILE_LOWPAN=/sys/class/net/lowpan0

if [ $RADIO_AVAILABLE == "TRUE" ] && [ ! -e "$FILE_LOWPAN" ];
then
    #Setting up the 6lowpan network
    echo "Bringing up the network"
    sudo iwpan dev wpan0 set pan_id 0xabcd
    sudo iwpan phy phy0 set channel 0 26

    sudo ip link add link wpan0 name lowpan0 type lowpan
    sudo ip link set wpan0 up
    sudo ip link set lowpan0 up

    sudo ip -6 route delete fe80::/64 dev wlan0 proto kernel metric 256 pref medium
    sudo ip -6 route delete fe80::/64 dev eth0 proto kernel metric 256 pref medium

    RADIO_READY="TRUE"

fi

echo "Source micro-ROS Agent"
source micro-ros_cc_ws/install/setup.bash #Change to the right folder
UROS_FOLDER=micro-ros_cc_ws/build/micro_ros_agent #Change to the right folder

clear

options=("Add new 6LoWPAN micro-ROS device" "Create UDP 6LoWPAN micro-ROS Agent" "Create UDP micro-ROS Agent" 
"Create TCP micro-ROS Agent" "Create Serial micro-ROS Agent server" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Add new 6LoWPAN micro-ROS device")
            #Due to the problemes with the incompabilities between the Linux and NuttX and 6LoWPAN stack,
            #is necessary to add manually a new device as neighbord
            clear
            read -n 39 -p "Please add the IPV6 of the new device: " CLIENT_IPV6
            sudo ip neigh add to $CLIENT_IPV6 dev lowpan0 lladdr 00:be:ad:de:00:de:fa:00
            echo "Added new device: $CLIENT_IPV6"
            ;;
        "Create UDP 6LoWPAN micro-ROS Agent")
            clear
            read -n 4 -p "Please type the port to use: " CLIENT_PORT
            $UROS_FOLDER/micro_ros_agent udp6 --port $CLIENT_PORT &
            ;;
        "Create UDP micro-ROS Agent")
            clear
            read -n 4 -p "Please type the port to use: " CLIENT_PORT
            $UROS_FOLDER/micro_ros_agent udp4 --port $CLIENT_PORT &
            ;;
        "Create TCP micro-ROS Agent")
            clear
            read -n 4 -p "Please type the port to use: " CLIENT_PORT
            $UROS_FOLDER/micro_ros_agent tcp4 --port $CLIENT_PORT &
            ;;
        "Create Serial micro-ROS Agent server")
            clear
            read -n 12 -p "Please add the route to the serial device: " CLIENT_PORT
            if [ -e "$CLIENT_PORT" ]; then
                $UROS_FOLDER/micro_ros_agent serial --dev $CLIENT_PORT &
            else
                echo "Device doesn't exist, please try again."
            fi
            ;;
        "Quit")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done
