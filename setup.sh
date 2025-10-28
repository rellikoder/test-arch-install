#!/bin/bash
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt /bin/bash < ./chroot.sh
umount -R /mnt