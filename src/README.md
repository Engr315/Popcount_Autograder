# Source for qemu-autograder

Build all using:
`make`

Each component can also be built individually using:

`make kernel`
`make rootfs`
`make module`
 
## Directory
- **kernel**: contains .config file and build script for linux kernel v5.10.4
- **rootfs**: contains .config file and build script for building rootfs
- **kernel_module**: contains source for the uio kernel module required to enable UIO device

