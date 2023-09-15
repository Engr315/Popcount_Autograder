all: kernel rootfs module

deps:
	sudo apt update && sudo apt upgrade
	sudo apt install e2cp

#all: kernel rootfs kernel
.PHONY: kernel
kernel:
	./kernel/makekernel.sh

.PHONY: rootfs
rootfs:
	./rootfs/makerootfs.sh

.PHONY: module
module: kernel
	(cd kernel_module; make all)

