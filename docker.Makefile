# THE DOCKER MAKEFILE FOR THE QEMU POPCOUNT PROJECT
# Written By: Matteo Vidali (mvidali@iu.edu)
# -----------------------------------------------
#  This file is responsible for all of the making required by the 
#  autograder docker image. That is: Installing the required dependancies,
#  and then getting and extracting the latest release of the popcount-qemu 
#  binaries.
# -----------------------------------------------
SHELL:=/bin/bash

.PHONY: deps
deps:
	sudo apt update
	sudo apt install -y libncurses5-dev \
											gcc-arm-linux-gnueabi \
											e2tools \
											wget \
											tar

qcomps:
	wget -q https://github.com/Engr315/Popcount_Autograder/releases/latest/download/qcomps.tar.gz
	tar -xf qcomps.tar.gz

