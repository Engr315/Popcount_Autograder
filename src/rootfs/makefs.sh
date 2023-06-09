#!/bin/bash

BR_LOC=buildroot

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
cp buildroot/output/images/*.ext2 .

echo "Finished filesystem creation"
