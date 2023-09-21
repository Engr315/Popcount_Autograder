# Author: Matteo Vidali
# ---------------------
# Version: 1.0
# Test makefile that the docker image will use to
# test the students code.
# ---------------------
IMG?=./compiled/uio-rootfs2.ext2
TEST=mmio
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
	e2cp ./S90$(TEST) $(IMG):/etc/init.d/S90run
	# Run QEMU
	$(DEVQEMU) -M virt,highmem=off \
    -cpu cortex-a15 \
		-semihosting \
    -m 128 -kernel $(KRNL) \
    -drive file=$(IMG),if=virtio,format=raw \
    -append "console=ttyAMA0,115200 root=/dev/vda" \
    -nographic
	e2rm $(IMG):/etc/init.d/S90run
	e2cp $(IMG):/stuff/output.txt ./result

.PHONY: test
test: 
	sed -n '/$(TEST_FILE)/p' result | grep $($(TEST_FILE)_V); test $$? -eq 0

.PHONY: test_time
test_time: $(TIME)
	$(OUTPUT_TIME) = sed -n '/$(TEST_FILE)/p' result | sed -n -e 's/^.*| //p' | bc -l 
	test $(echo "$(OUTPUT_TIME) < $(TIME)" | bc) -ne 0

user_$(TEST).arm: user_$(TEST).c
	arm-linux-gnueabi-gcc -static -o user_$(TEST).arm user_$(TEST).c	

place_script:	user_$(TEST).arm
	e2cp user_$(TEST).arm $(IMG):/stuff/

place_test: $(TEST_FILE) 
	e2cp $(TEST_FILE) $(IMG):/stuff/files/$(TEST_FILE)

clean:
	rm -rf *.arm
