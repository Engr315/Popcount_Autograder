IMG?=./compiled/uio-rootfs2.ext2
SRC?=user_mmio.c
OUTNAME=uio.arm
DEVQEMU=qemu/bin/qemu-system-arm
KRNL=compiled/uio_linux-5.10.4.zImage 
IMG=compiled/autograder.ext2

TEST_FILE=zeros.bin

zeros.bin_V="0"
ones.bin_V="2048"
tiny.bin_V="968"
small.bin_V="16314"
medium.bin_V="4196661"
large.bin_V="41941497"

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
test: 
	sed -n '/$(TEST_FILE)/p' compare | grep $($(TEST_FILE)_V); test $$? -eq 0

$(OUTNAME): user_mmio.c
	arm-linux-gnueabi-gcc -static -o $(OUTNAME) $(SRC)	

place_script:	$(OUTNAME)
	e2cp $(OUTNAME) $(IMG):/stuff/$(OUTNAME)

place_test: $(TEST_FILE) 
	e2cp $(TEST_FILE) $(IMG):/stuff/files/$(TEST_FILE)

clean:
	rm -rf uio.arm
