# Compiled Binary Files

This folder contains all the necessary compiled binary files to run the QEMU
virt machine with the custom popcount hardware on the autograder as well as 
locally on your machine.

## Contents
### Binaries
 - `uio_pcnt.ko` - is the compiled kernel driver required for the uio device
 - `uio_linux-5.10.4.zImage` - is the custom kernel to run the QEMU instance with
### Filesystems
 - `autograder.ext2` 
    - This is the compiled ext2 filesystem to run on the autograder. It contains 
    The kernel module binary, and the startup scripts required to insert the kernel
    module and run the userspace driver over all of the binaries. The binaries are
    already inside of this image, but can be replaced.
    This filesystem will run the required tests, put the result into output.txt, and 
    then shutdown. This means it will not be useful for debugging, but will run well
    on the autograder. 
 - `./uio-rootfs.ext2`
    - This is the debugging version of the above filesystem. It does everything 
    the same, but DOES NOT POWEROFF automatically. this means you will be left 
    in the QEMU machine with all the binaries and the result files, but with the 
    ability to poke around.
