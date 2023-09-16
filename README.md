# QEMU - Emulated Popcount Device

Written by: Matteo Vidali [mvidali@iu.edu](mvidali@iu.edu)

For questions and Concerns regarding this system - email Matteo Vidali,
or make a pull request.

## Installation and Building
There are several ways to use and build this package. 

1. Use the prebuilt release present in the `latest release` tag.
    This is what the autograder dockerfile uses to set itself up.
2. Building for the autograder with precompiled binaries
    This build method builds the autograder package wich includes:
        1. A custom QEMU image with `dma` and `mmio` popcount built in
        2. A Makefile that will install dependancies cross compile the students file, and run the QEMU instance 
        3. A precompiled e2fs with precompiled kernel modules, datafiles which will automatically run and exit itself.
3. Building for local testing with precompiled binaries
    This is for running the qemu instance as an emulated system for testing.
    It utilizes the same QEMU instance, but a different e2fs disk image that will not shut itself down. 
    It contains the same precompiled binaries, and can be used as a test platform.
4. Building completley from scratch
    All source files for the precompiled binaries and kernel are included, and have assiciated build scripts
    these are all located in the `/src` directory.

### Building Autograder From Release
To use this package with the autograder, simply download the `Dockerfile` and `docker.Makefile`
from the main directory and build a custom sandbox image in the autograder using these.
This will pull from the latest release, and use the latest binaries.

### Building for Autograder with pre-compiled binaries (From Source)
To build the tar.gz that is pulled by the autograder docker Makefile, do the following:

1. First Clone the repository:
    `git clone https://github.com/Engr315/Popcount_Autograder.git`
2. Now run the following `make` command
    `make qcomps.tar.gz`

This will run all of the steps to build the `tar.gz` file published in the releases. 

### Building for local testing with pre-compiled binaries (From Source)
This will build the same as above, but specifically for local testing. 
QEMU will be built, and the disk image is already prebuilt.

To build, run:
`make`

Then to run the system:
`make qemu-run`

To put things in the filesystem, see section "Putting things in File System":

### Building everything from scratch
To build QEMU, either run:

`make build-qemu`

To build the testing version of QEMU which has more functionoality AND REQUIRES MORE DEPENDANCIES & DYNAMICALLY LINKED LIBRARIES!

Or run:

`make build-qemu-pack`

To build the condensed version of qemu with most features disabled and all dynamic libraries included.


To build the Kernel, Kernel Module, and Rootfs, you can run:

`make build-components`

Which will build all three, or you can build them each individually via:

```bash
    cd src
    make kernel
    make kernel_module
    make rootfs
```

or by running the shell build scripts in the individual component directories.

**NOTE**: you must build or have built the kernel in the past to build the kernel\_module as it requires the kernel directory to build

### Putting things in filesystem
To put files into the qmeu filesystem, run:

`make item_go_in ITEM=<path/to/file> INAME=<desired/file/name>`

If you want to place the item in an image other than the testing image (`compiled_uio.e2fs`) specify with the argument:

`IMG=<path/to/e2fs>`

This will place your item in the `/stuff` folder in the desired image

## Documentation and Info

### Changes to the Filesystem
To enable autologin, the file `/etc/inittab` was edited to change the line `console::respawn:/sbin/getty -L console 0 vt100` to `::respawn:-/bin/sh`
