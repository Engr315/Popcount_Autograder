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
- **misc**: contains important files for the autograder.
    - `compare`: a comparison file of good outputs of running popcount on each file
    - `Makefile`: The main testing makefile for the autograder - includes `make result` and `make test`
    - `README.md`: currently empty readme: #TODO: Describe operation of makefile in readme here.
    - `S90dma`: is a start shell script which will run the student dma popcount inside of qemu and shut down the system. This will be placed onto the QEMU disk image in the event of testing student DMA code.
    - `S90mmio`: is a start shell script to run student `user_mmio.arm` file inside of qemu, and shutdown the system. To be used in the event of testing student mmio code.
