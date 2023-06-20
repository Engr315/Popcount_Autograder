IMG?=./compiled/uio-rootfs2.ext2
SRC?=user_mmio.c
OUTNAME=uio.arm
DEVQEMU=qemu/bin/qemu-system-arm
KRNL=compiled/uio_linux-5.10.4.zImage 
IMG=compiled/autograder.ext2

ZEROS="0"
ONES="2048"
TINY="968"
SMALL="16314"
MEDIUM="4196661"
LARGE="41941497"

result: place_script
	# Run QEMU
	$(DEVQEMU) -M virt,highmem=off \
    -cpu cortex-a15 \
		-semihosting \
    -m 128 -kernel $(KRNL) \
    -drive file=$(IMG),if=virtio,format=raw \
    -append "console=ttyAMA0,115200 root=/dev/vda" \
    -nographic
	
	if [ ! -d "mnt" ]; then mkdir -p mnt; fi
	sudo mount $(IMG) mnt
	sudo cp mnt/stuff/output.txt ./result
	sudo umount mnt
	sudo rmdir mnt	

.PHONY: test
test: result
	sed '1!d' result | grep $(ZEROS); test $$? -eq 0
	sed '2!d' result | grep $(ONES); test $$? -eq 0
	sed '3!d' result | grep $(TINY); test $$? -eq 0
	sed '4!d' result | grep $(SMALL); test $$? -eq 0
	sed '5!d' result | grep $(MEDIUM); test $$? -eq 0
	sed '6!d' result | grep $(LARGE); test $$? -eq 0

$(OUTNAME): user_mmio.c
	arm-linux-gnueabi-gcc -static -o $(OUTNAME) $(SRC)	

place_script:	$(OUTNAME)
	if [ ! -d "mnt" ]; then mkdir -p mnt; fi
	sudo mount $(IMG) mnt 
	if [ -f "./mnt/stuff/$(OUTNAME)" ]; then sudo rm ./mnt/stuff/$(OUTNAME); fi
	sudo cp $(OUTNAME) ./mnt/stuff/$(OUTNAME)
	sudo umount ./mnt
	rmdir ./mnt

clean:
	rm -rf uio.arm
