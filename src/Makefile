
all: kernel rootfs module

deps:
	sudo apt update && sudo apt upgrade
	sudo apt install e2cp
kernel:
	./kernel/makekernel.sh

rootfs:
	./rootfs/makerootfs.sh

module: kernel
	(cd kernel_module; make all)

