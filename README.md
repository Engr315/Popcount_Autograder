# QEMU - Emulated Popcount Device

Written by: Matteo Vidali [mvidali@iu.edu](mvidali@iu.edu)

For questions and Concerns regarding this system - email Matteo Vidali,
or make a pull request.

## Installation and Building
To use this package with the autograder, simply download the Dockerfile and Makefile
from the main directory and build a custom sandbox image in the autograder using these.

This will pull from the latest release, and use the latest binaries.

### DEBIAN ONLY: Automated
Clone this repository as it is:
`git clone https://github.com/Engr315/Popcount_Autograder.git`

To install dependancies, build binaries and run the qemu system, run:
`make`

To create the release, the command 
`make assemble-qemu-pack`
can be used. This will build qemu with as few necessary dynamic libraries as possible,
and then take only the necessary files for the autograder to run and package them 
along with the other required files (like Makefile etc.) into the tar.gz file.

### DEBIAN & RHEL - Multi-command setup
For a more controlled installation process, begin by installing requirements with:

Debian: `make deps`

RHEL: `make deps-rhel`

Then the binaries can be built with:
`make build`

To make just the QEMU binary, run:
`make build-qemu`

To run the system, run:
`make run`

## Documentation and Info

### Changes to the Filesystem
To enable autologin, the file `/etc/inittab` was edited to change the line `console::respawn:/sbin/getty -L console 0 vt100` to `::respawn:-/bin/sh`
