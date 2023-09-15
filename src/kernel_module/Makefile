PWD := $(shell pwd)
obj-m += uio_pcnt.o
KERNEL=../kernel/linux-5.10.4

all:
	make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- -C $(KERNEL) M=$(PWD) modules
clean:
	make -C $(KERNEL) M=$(PWD) clean
