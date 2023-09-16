all: kernel rootfs module

deps:
	sudo apt update && sudo apt upgrade
	sudo apt install e2cp

#all: kernel rootfs kernel
.PHONY: kernel
kernel:
	./kernel/make_kernel.sh
	echo "MADE KERNEL"

.PHONY: rootfs
rootfs:
	./rootfs/makerootfs.sh
	echo "MADE ROOTFS"

.PHONY: module
module: kernel
	(cd kernel_module; make all)
	echo "MADE MODULE"

