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
	
	e2cp $(IMG):/stuff/output.txt ./result


.PHONY: test
test_zero: result
	sed '1!d' result | grep $(ZEROS); test $$? -eq 0
test_ones: result
	sed '2!d' result | grep $(ONES); test $$? -eq 0
test_tiny: result
	sed '3!d' result | grep $(TINY); test $$? -eq 0
test_small: result
	sed '4!d' result | grep $(SMALL); test $$? -eq 0
test_medium: result
	sed '5!d' result | grep $(MEDIUM); test $$? -eq 0
test_large: result
	sed '6!d' result | grep $(LARGE); test $$? -eq 0

$(OUTNAME): user_mmio.c
	arm-linux-gnueabi-gcc -static -o $(OUTNAME) $(SRC)	

place_script:	$(OUTNAME)
	e2cp $(OUTNAME) $(IMG):/stuff/$(OUTNAME)

clean:
	rm -rf uio.arm
