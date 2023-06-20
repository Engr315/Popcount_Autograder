sudo mount -o loop uio-rootfs.ext2 /mnt/uio
sudo mkdir /mnt/uio/stuff
sudo mkdir /mnt/uio/etc/modules
sudo mkdir /mnt/uio/stuff/files
sudo cp ../../compiled/uio_pcnt.ko /mnt/uio/etc/modules/uio_pcnt.ko
sudo cp internal/inittab /mnt/uio/etc/inittab
sudo cp internal/S80modules /mnt/uio/etc/init.d/
sudo cp internal/S90popcount /mnt/uio/etc/init.d/
sudo cp internal/data/* /mnt/uio/stuff/files/
sudo chmod u+x /mnt/uio/etc/init.d/S80modules
sudo chmod u+x /mnt/uio/etc/init.d/S90popcount
sudo umount /mnt/uio
sudo rmdir /mnt/uio
echo "Finished filesystem creation"
