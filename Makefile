# THE BUID MAKEFILE FOR THE QEMU POPCOUNT PROJECT
# Written By: Matteo Vidali (mvidali@iu.edu)
# -----------------------------------------------
#  This file is responsible for alot of things, but 
#  mainly it is repsponsible for setting up and using the debug version of 
#  the qemu popcount system from source.
# -----------------------------------------------

SHELL:=/bin/bash

# Important names and locations of compiled binaries
# These can be recompiled from source in the ./src directory
KRNL?=./compiled/uio_linux-5.10.4.zImage
IMG?=./compiled/uio-rootfs.ext2

# Location of the qemu-system binary after building
DEVQEMU?=./qemu315/build/qemu-system-arm

# Installs dependancies, Builds qemu315 from scratch and runs the simulation
.PHONY: all
all: deps build src run

src: 
	(cd src; make all)
# Runs the qemu system emulator with emulated device and populated filesystem
.PHONY: run
run: qemu-w-device

# Installs ALL necessary dependancies for this build
# These dependancies are to BUILD AND RUN - some may be extra
# for simply running 
# TODO: Split this out into those required for building and thos responsibe 
# 			for running
.PHONY: deps
deps:
	sudo apt update
	sudo apt install -y libc6-armel-cross \
											libc6-dev-armel-cross \
											binutils-arm-linux-gnueabi \
											libncurses5-dev \
											build-essential \
											bison \
											flex \
											libssl-dev \
											bc \
											ninja-build \
											libglib2.0-dev \
											libpixman-1-dev \
											gcc-arm-linux-gnueabi \
											libfdt-dev\
											e2tools

# An attempt at covering all the required dependancies on RHEL
# This is not working, but the skeleton is there.
# NinjaBuild needs to be compiled from scratch, and analogs for the deps target 
# must be found
# TODO: Port all dependancies to RHEL
.PHONY: deps-rhel
deps-rhel:
	sudo yum install git glib2-devel libfdt-devel pixman-devel zlib-devel bzip2 ninja-build python3

# A generic buiid target to capture all potential build targets
build: build-qemu

# the general clean target
clean: clean-qemu clean-qemu-pack

# A dirty shortcut to place the kernel object - depreciated - should
# be replaced with e2cp <e2tools>
place-ko: item_go_in ITEM=./compiled/uio_pcnt.ko INAME=uio_pcnt.ko

# Builds qemu from the custom repository Contains all libraries
# and is not intended for packaging - this is for debuging and testing only
.PHONY: build-qemu
build-qemu:
	if [ ! -d "./qemu315/build" ]; then \
		git submodule update --init --remote; \
		cd qemu315 && git pull origin master && mkdir build; \
	fi
	if [ ! -f "./qemu315/build/Makefile" ]; then \
		cd qemu315/build && ../configure --target-list=arm-softmmu; \
	fi
	#(cd qemu315/build-inst; make -j$(nproc) install DESTDIR=./package_install)
	(cd qemu315/build; make -j$(nproc))

.PHONY: build-components
build-components:
	cd src && make kernel && make kernel_module && make rootfs

# Builds qemu with as few enabled libraries as possible
# May still be able to build with the --disable-fdt flag to remove dependancy
# on libfdt-dev
# TODO: confirm libfdt is superflous and remove it
.PHONY: build-qemu-pack
build-qemu-pack:
	if [ ! -d "./qemu315/build-inst" ]; then \
		git submodule update --init --remote; \
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

# Assembles the release binaries and other required files
# Only takes what is absolutley necessary (plus some extra lol)
# into the qcomps folder and subsequently into the qcomps.tar.gz
qcomps: build-qemu-pack
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

qcomps.tar.gz: qcomps
	tar -cvzf qcomps.tar.gz qcomps

# A clean target for the assembly process assemble-qemu-pack
.PHONY: clean-qemu-pack
clean-qemu-pack:
	rm -rf qcomps
	rm -rf qemu315/build-inst
	rm -rf qcomps.tar.gz

# will run qemu from the tarball (if only have release) no need to build
.PHONY: run-from-tar
run-from-tar: qcomps.tar.gz
	if [ ! -d "./qcomps" ]; then \
		tar -xzvf qcomps.tar.gz; \
	fi
	make run DEVQEMU=qcomps/qemu/bin/qemu-system-arm \
		KRNL=qcomps/compiled/uio_linux-5.10.4.zImage \
		IMG=qcomps/compiled/uio-rootfs2.ext2

# Cleans the qemu builds
.PHONY: clean-qemu
clean-qemu:
	rm -rf qemu315/build
	rm -rf qemu315/build-static

# Correct running of the qemu system - DOES NOT contains popcount hardware
# Relies on you having installed qemu-system-arm via apt or other system 
# package manager, or, if you are particular - done a proper installation from source.
.PHONY: qemu-stock
qemu-stock: /bin/qemu-system-arm
	/bin/qemu-system-arm -M virt,highmem=off \
			-cpu cortex-a15 \
			-m 128 -kernel $(KRNL) \
			-drive file=$(IMG),if=virtio,format=raw \
			-append "console=ttyAMA0,115200 root=/dev/vda" \
			-nographic

# Correct running of the qemu system - contains popcount hardware
# This can also have the -semihosting argument if desired, but found to be 
# unnecessary
.PHONY: qemu-w-device
qemu-w-device:
	$(DEVQEMU) -M virt,highmem=off \
    -cpu cortex-a15 \
    -m 128 -kernel $(KRNL) \
    -drive file=$(IMG),if=virtio,format=raw \
    -append "console=ttyAMA0,115200 root=/dev/vda" \
    -nographic

# runs qemu with the axi_dma device included
.PHONY: qemu-w-DMA
qemu-w-DMA:
	$(DEVQEMU) -M virt,highmem=off \
    -cpu cortex-a15 \
    -m 128 -kernel $(KRNL) \
		-device xlnx.axi-dma \
    -drive file=$(IMG),if=virtio,format=raw \
    -append "console=ttyAMA0,115200 root=/dev/vda" \
    -nographic


# A generic script to put items into an ext2 image
# This is somewhat depreciated and has been replaced with e2cp <e2tools>
# TODO: USE E2CP HERE
item_go_in: $(ITEM) $(INAME)
	if [ ! -d "/mnt/uio" ]; then sudo mkdir /mnt/uio; fi
	sudo mount -o loop $(IMG) /mnt/uio
	sudo cp $(ITEM) /mnt/uio/stuff/$(INAME)
	sudo umount /mnt/uio
