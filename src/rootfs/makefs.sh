#!/bin/bash

BR_LOC=./buildroot

if [ ! -d "./$BR_LOC"]; then
  echo "No Buildroot directory present... exit and move buildroot to ./$BR_LOC"
  echo "Or press any key to clone buildroot"
  read
  echo "Getting Buildroot..."
  git clone https://github.com/buildroot/buildroot.git
else
  echo "Found buildroot..."
fi

echo "Press any key to overwrite buildroot .config and build rootfs..."
read
cp buildroot.config buildroot/.config
cd buildroot && make -j$(nproc)
cp buildroot/output/images/*.ext2 ./uio-rootfs.ext2

echo "Press any key to setup rootfs for popcount"
read

# Ensure the mount directory is prepared
if [ ! -d "/mnt/uio" ]; then
  sudo mkdir /mnt/uio/
fi

# Mount the image
sudo mount -o loop uio-rootfs.ext2 /mnt/uio

# Create requried directories
sudo mkdir /mnt/uio/stuff
sudo mkdir /mnt/uio/etc/modules
sudo mkdir /mnt/uio/stuff/files

# Place required files
sudo cp ../../compiled/uio_pcnt.ko /mnt/uio/etc/modules/uio_pcnt.ko
sudo cp internal/inittab /mnt/uio/etc/inittab
sudo cp internal/S80modules /mnt/uio/etc/init.d/
sudo cp internal/S90popcount /mnt/uio/etc/init.d/
sudo cp internal/data/* /mnt/uio/stuff/files/

# change permissions to allow run at start
sudo chmod u+x /mnt/uio/etc/init.d/S80modules
sudo chmod u+x /mnt/uio/etc/init.d/S90popcount

# cleanup
sudo umount /mnt/uio
sudo rmdir /mnt/uio
echo "Finished filesystem creation"
