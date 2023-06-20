SHELL:=/bin/bash

# Important names and locations
HOST_ADAPTER?=enx001cc25eb9e1
KRNL?=./compiled/uio_linux-5.10.4.zImage
IMG?=./compiled/uio-rootfs.ext2

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
		build-essential bison flex libssl-dev bc ninja-build libglib2.0-dev libpixman-1-dev

deps-rhel:
	sudo yum install git glib2-devel libfdt-devel pixman-devel zlib-devel bzip2 ninja-build python3

build: build-qemu

clean: clean-qemu clean-qemu-pack

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

#cd qemu315/build-inst && ../configure --target-list=arm-softmmu --disable-sdl; 
build-qemu-pack: 
	if [ ! -d "./qemu315/build-inst" ]; then \
		cd qemu315 && mkdir build-inst; \
	fi
	if [ ! -f "./qemu315/build-inst/Makefile" ]; then \
		cd qemu315/build-inst && ../configure --target-list=arm-softmmu \
		--disable-tools --disable-sdl --disable-gtk --disable-vnc --disable-virtfs \
		--disable-attr --disable-libiscsi --disable-libnfs --disable-libusb \
		--disable-opengl --disable-numa --disable-usb-redir --disable-bzip2 \
		--audio-drv-list= --disable-guest-agent --disable-vte --disable-mpath \
		--disable-sndio --disable-alsa --disable-slirp --disable-pa --disable-gio\
		--disable-curses \
		--disable-libudev --disable-vhost-user --disable-curl --disable-gnutls; \
	fi
	(cd qemu315/build-inst; make -j$(nproc) install DESTDIR=./package_install)

assemble-qemu-pack: build-qemu-pack
	# Getting required components of qemu and placing them here
	mkdir -p qcomps/{qemu/share/qemu/{firmware,keymaps},compiled}
	cp -r qemu315/build-inst/package_install/usr/local/bin qcomps/qemu/bin
	cp -r qemu315/build-inst/package_install/usr/local/include/ qcomps/qemu/include
	cp qemu315/build-inst/package_install/usr/local/share/qemu/{efi-virtio.rom,qboot.rom,vof.bin} qcomps/qemu/share/qemu
	cp -r qemu315/build-inst/package_install/usr/local/share/qemu/firmware/ qcomps/qemu/share/qemu/firmware/
	cp qemu315/build-inst/package_install/usr/local/share/qemu/keymaps/en-us qcomps/qemu/share/qemu/keymaps/
	# Getting precompiled components and placing them here
	cp compiled/{autograder.ext2,uio_linux-5.10.4.zImage} qcomps/compiled/
	# Get qcomps required files into the folder
	cp src/misc/* qcomps
	tar -cvzf qcomps.tar.gz qcomps

clean-qemu-pack:
	rm -rf qcomps
	rm -rf qemu315/build-inst

run-from-tar:
	if [ ! -d "./qcomps" ]; then \
		tar -xzvf qcomps.tar.gz; \
	fi
	make run DEVQEMU=qcomps/qemu/bin/qemu-system-arm \
		KRNL=qcomps/compiled/uio_linux-5.10.4.zImage \
		IMG=qcomps/compiled/uio-rootfs2.ext2

clean-qemu:
	rm -rf qemu315/build
	rm -rf qemu315/build-static

clean-tar:
	rm -rf qcomps

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

get-qcomps:
	wget https://github.com/Engr315/Popcount_Autograder/releases/latest/download/qcomps.tar.gz
	tar -xf qcomps.tar.gz
