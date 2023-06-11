SHELL:=/bin/bash

# Important names and locations
HOST_ADAPTER?=enx001cc25eb9e1
KRNL?=./compiled/uio_linux-5.10.4.zImage
IMG?=./compiled/uio-rootfs2.ext2

# Variables for loading things into the image
ITEM?=../../experiments/user-drivers/uio.arm
INAME?=uio.arm

# QEMU - Custom
DEVQEMU?=./qemu315/build/qemu-system-arm

all: deps build run

# Runs the qemu system emulator with emulated device and populated filesystem
run: qemu-w-device

deps:
	sudo apt update
	sudo apt install -y libc6-armel-cross libc6-dev-armel-cross binutils-arm-linux-gnueabi libncurses5-dev \
		build-essential bison flex libssl-dev bc ninja-build libglib2.0-dev

deps-rhel:
	sudo yum install git glib2-devel libfdt-devel pixman-devel zlib-devel bzip2 ninja-build python3

build: build-qemu

clean: clean-qemu

place-ko: item_go_in ITEM=./compiled/uio_pcnt.ko INAME=uio_pcnt.ko

build-qemu:
	if [ ! -d "./qemu315/build" ]; then \
		git submodule update --init --remote; \
		cd qemu315 && mkdir build; \
	fi
	if [ ! -f "./qemu315/build/Makefile" ]; then \
		cd qemu315/build && ../configure --target-list=arm-softmmu; \
	fi
	(cd qemu315/build; make -j$(nproc))

run-from-tar:
	if [ ! -d "./qcomps" ]; then \
		tar -xzvf qcomps.tar.gz; \
	fi
	make run DEVQEMU=qcomps/build/qemu-system-arm \
		KRNL=qcomps/compiled/uio_linux-5.10.4.zImage \
		IMG=qcomps/compiled/uio-rootfs2.ext2

clean-qemu:
	rm -rf qemu315/build

qemu-stock:
	/bin/qemu-system-arm -M virt,highmem=off \
			-cpu cortex-a15 \
			-m 128 -kernel $(KRNL) \
			-drive file=$(IMG),if=virtio,format=raw \
			-append "console=ttyAMA0,115200 root=/dev/vda" \
			-nographic

qemu-w-device:
	$(DEVQEMU) -M virt,highmem=off \
    -cpu cortex-a15 \
    -m 128 -kernel $(KRNL) \
    -drive file=$(IMG),if=virtio,format=raw \
    -append "console=ttyAMA0,115200 root=/dev/vda" \
    -nographic

item_go_in:
	if [ ! -d "/mnt/uio" ]; then sudo mkdir /mnt/uio; fi
	sudo mount -o loop $(IMG) /mnt/uio
	sudo cp $(ITEM) /mnt/uio/stuff/$(INAME)
	sudo umount /mnt/uio
