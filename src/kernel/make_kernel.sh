#!/bin/bash

# Author: Matteo Vidali <mvidali@iu.edu>
# Version: 0.1
# Usage: Run this file to compile the custom linux kernel v5.10.4

KERN_LOC=linux-5.10.4
KERN_TAR="$KERN_LOC.tar.gz"

# Locate Linux Kernel Directory
if [ ! -d "./$KERN_LOC"]; then
  echo "No kernel directory present. exit and move kernel directory to ./$KERN_LOC"
  echo "Or press any key to download and extract new kernel tar..."
  read
  if [ ! -f "$KERN_TAR"]; then
    echo "Getting kernel"
    wget https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/snapshot/linux-5.10.4.tar.gz
    
  echo "Extracting Kernel"
  tar -xzvf linux-5.10.4.tar.gz
else
  echo "Found Kernel..."
fi

echo "Press any key to overwrite linux .config and build kernel..."
read
echo "Building Linux..."
cd linux-5.10.4 && make mrproper
cp uio_linux-5.10.4.config linux-5.10.4/.config

if ! command -v arm-linux-gnueabi-gcc &> /dev/null; then
  echo "No cross compiler detected on system..."
  echo "Press any key to install the cross compiler toolchanin"
  read
  echo "Installing cross compiler... NOTE - SOME DEPS MAY BE MISSING"
  echo "PLEASE RUN 'make deps' FROM THE MAIN MAKEFILE TO ENSURE FUNCTIONALITY..."
  sudo apt update
  sudo apt install gcc-arm-linux-gnueabi 
else
  echo "Found cross compiler"
fi

cd linux-5.10.4 && make -j($nproc) ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- zImage
cp linux-5.10.4/arch/arm/boot/zImage ./uio_linux-5.10.4.zImage

echo "Finished building... 
