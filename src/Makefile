
all: kernel rootfs kernel

kernel:
	./kernel/makekernel.sh

rootfs:
	./rootfs/makerootfs.sh

module: kernel
	(cd kernel_module; make all)

