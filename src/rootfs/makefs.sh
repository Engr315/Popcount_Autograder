#!/bin/bash

BR_LOC=./buildroot

if [ ! -d "./$BR_LOC" ]; then
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
cp buildroot/output/images/*.ext2 ./uio-rootfs_popcount.ext2
cp buildroot/output/images/*.ext2 ./uio-rootfs_dma.ext2

echo "Press any key to setup rootfs for popcount"
read

# Ensure the mount directory is prepared
if [ ! -d "/mnt/uio_pct" ]; then
  sudo mkdir /mnt/uio_pct/
fi
if [ ! -d "/mnt/uio_dma" ]; then
  sudo mkdir /mnt/uio_dma/
fi

# Mount the image
sudo mount -o loop uio-rootfs_popcount.ext2 /mnt/uio_pct
sudo mount -o loop uio-rootfs_dma.ext2 /mnt/uio_dma

# Create requried directories
sudo mkdir /mnt/uio_pct/stuff
sudo mkdir /mnt/uio_dma/stuff
sudo mkdir /mnt/uio_pct/etc/modules
sudo mkdir /mnt/uio_dma/etc/modules
sudo mkdir /mnt/uio_pct/stuff/files
sudo mkdir /mnt/uio_dma/stuff/files

# Place required files
sudo cp ../../compiled/uio_pcnt.ko /mnt/uio_pct/etc/modules/uio_pcnt.ko
sudo cp internal/inittab /mnt/uio_pct/etc/inittab
sudo cp internal/S80modules /mnt/uio_pct/etc/init.d/
sudo cp internal/S90popcount /mnt/uio_pct/etc/init.d/
sudo cp internal/data/* /mnt/uio_pct/stuff/files/
sudo cp ../../compiled/uio_pcnt.ko /mnt/uio_dma/etc/modules/uio_pcnt.ko
sudo cp internal/inittab /mnt/uio_dma/etc/inittab
sudo cp internal/S80modules /mnt/uio_dma/etc/init.d/
sudo cp internal/S90dma /mnt/uio_dma/etc/init.d/
sudo cp internal/data/* /mnt/uio_dma/stuff/files/

# change permissions to allow run at start
sudo chmod u+x /mnt/uio_pct/etc/init.d/S80modules
sudo chmod u+x /mnt/uio_dma/etc/init.d/S80modules
sudo chmod u+x /mnt/uio_pct/etc/init.d/S90popcount
sudo chmod u+x /mnt/uio_dma/etc/init.d/S90dma

# cleanup
sudo umount /mnt/uio_pct
sudo umount /mnt/uio_dma
sudo rmdir /mnt/uio_pct
sudo rmdir /mnt/uio_dma
echo "Finished filesystem creation"
