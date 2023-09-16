#!/bin/bash
# Author: Matteo Vidali <mvidali@iu.edu>
# Version: 1.0
# Usage: Run this file to compile the custom linux kernel v5.10.4
KERN_LOC=./linux-5.10.4
KERN_TAR="$KERN_LOC.tar.gz"
# Print welcome message and locate Linux Kernel Directory
echo "Welcome to the popcount autograder kernel compilation process!"
echo "--------------------------------------------------------------"
echo "NOTE: THIS PROCESS TAKES SOME TIME ON SMALLER MACHINES!"
echo ""
echo "Looking for populated kernel folder @ $KERN_LOC..."
# Checking for kernel directory
if [ ! -d "./$KERN_LOC" ]; then
  echo "No kernel directory present. exit and move kernel directory to ./$KERN_LOC"
  echo "Or press any key to download and/or extract new kernel tar..."
  read
  # Download the tar.gz from linux archives
  # NOTE! if this is down, I belive the official linux github
  # 	  tag v5.10 SHOULD work for this. As of 9/8/2023 it has not been verified to work.
  if [ ! -f "$KERN_TAR" ]; then
    echo "Getting kernel"
    wget https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/snapshot/linux-5.10.4.tar.gz
  fi
  echo "Extracting Kernel"
  tar -xzvf linux-5.10.4.tar.gz
else
  echo "Found Kernel..."
fi
# Copy the premade config file into the kernel build directory
echo "Press any key to overwrite linux .config and build kernel..."
read
# Linux kernel build process
echo "Building Linux..."
cd linux-5.10.4 && make mrproper
cp ../uio_linux-5.10.4.config .config
# If no cross compiler is present, install one.
if [ ! command -v arm-linux-gnueabi-gcc &> /dev/null ]; then
  echo "No cross compiler detected on system..."
  echo "Press any key to install the cross compiler toolchanin"
  read
  echo "Installing cross compiler... NOTE - SOME DEPS MAY BE MISSING"
  echo "PLEASE RUN 'make deps' FROM THE MAIN MAKEFILE TO ENSURE FUNCTIONALITY..."
  sudo apt update
  sudo apt install gcc-arm-linux-gnueabi 
else
  echo "Found cross compiler";
fi
# Make the kernel AND MODULES (required to build uio kernel module)
make -j$(nproc) ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- zImage
make -j$(nproc) ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- modules
cp arch/arm/boot/zImage ../uio_linux-5.10.4.zImage
echo "Finished building..."
