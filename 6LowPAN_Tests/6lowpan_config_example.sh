#!/bin/bash

#This is a example of how to set-up the radio network using iwpan

sudo iwpan dev wpan0 set pan_id 0xabcd #Set the panid
sudo iwpan phy phy0 set channel 0 26 #Set the radio channel
sudo ip link add link wpan0 name lowpan0 type lowpan 
sudo ip link set wpan0 up
sudo ip link set lowpan0 up