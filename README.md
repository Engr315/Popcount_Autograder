# QEMU - Emulated Popcount Device

Written by: Matteo Vidali [mvidali@iu.edu](mvidali@iu.edu)

For questions and Concerns regarding this system - email Matteo Vidali,
or make a pull request.

## Installation and Building
Clone this repository as it is:
`git clone https://github.com/Engr315/Popcount_Autograder.git`

ON DEBIAN ONLY: To install dependancies, build binaries and run the qemu system, run:
`make`

For a more controlled installation process, begin by installing requirements with:

Debian: `make deps`
RHEL: `make deps-rhel`
RHEL: 
Then the binaries can be built with:
`make build`

To make just the QEMU binary, run:
`make build-qemu`

To run the system, run:
`make run`

## Changes to the Filesystem
To enable autologin, the file `/etc/inittab` was edited to change the line `console::respawn:/sbin/getty -L console 0 vt100` to `::respawn:-/bin/sh`
