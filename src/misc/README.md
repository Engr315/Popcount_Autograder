# AUTOGRADER USAGE INSTRUCTIONS
The general premise of the autograder is as follows:

## Author
- Matteo Vidali: mvidali@iu.edu or mmvidali@gmail.com

For questions or concerns, contact Matteo Vidali. In the event of no response, contact Dr. Andrew Lukefahr.

## Components
The autograder requires:

1. custom binary of QEMU with popcount and custom dma built in (qemu315)
2. custom arm linux kernel (kernel version 5.10.4) #TODO: check if 5.10 works from linux github 
3. custom kernel module to setup popcount as a uio device (uio_pcnt.ko)
4. kernel module to create and setup the DMA buffer
5. small disk image preloaded with relavent binaries

## General program theory

The autograder will do the following steps:

1. Cross compile the students code to an arm executable labeled with the `.arm` extension
2. Copy the `.arm` executable into the QEMU e2fs disk image (autograder.e2fs) into the `/stuff` directory
3. Copy the relevant startup shell script (`S90dma` or `S90mmio`) into the `/etc/init.d/S90run` file
4. Boot QEMU with this newley edited disk image
5. QEMU will boot, and insert the relevant kernel modules, and run the start script.
6. The student executable will be run over all of the files in `/stuff/files` (which comes from `/src/rootfs/internal/data`)
7. The `stdout` output of the student files will be redirected into `output.txt` 
8. `output.txt` will then be copied out of the e2fs filesystem, into `result`

Next the Testing steps can happen, comparing `result` to `compare`.

## Running this

To run this is quite simple. To generate `result` from the student code, simply, with the `<student>.c` file in the same directory as `Makefile`, run:

Testing DMA:

`make result TEST=dma`

Testing MMIO:

`make result TEST=mmio`

Then, to check the result of the student file for correctness, simply run:

`make test TEST_FILE=<zeros, ones, small, medium, large>.bin`

And look for a return code of 0 (success).


