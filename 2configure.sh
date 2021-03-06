# configuring miguel boot entry
#arch-chroot /mnt grep "UUID=" /etc/fstab | grep '/ ' | awk '{ print $1 }' | sed -e 's/UUID=//' > .root_disk_uuid
#arch-chroot /mnt touch /boot/loader/entries/miguel.conf
#arch-chroot /mnt echo "title miguel" >> /boot/loader/entries/miguel.conf
#arch-chroot /mnt echo "linux /vmlinuz-linux" >> /boot/loader/entries/miguel.conf
#arch-chroot /mnt echo "initrd /amd-ucode.img" >> /boot/loader/entries/miguel.conf
#arch-chroot /mnt echo "initrd /initramfs-linux.img" >> /boot/loader/entries/miguel.conf
#arch-chroot /mnt echo 'options root="UUID=root_disk_uuid" rw' >> /boot/loader/entries/miguel.conf
#arch-chroot /mnt sed -ie "s/root_disk_uuid/$(cat .root_disk_uuid)/g" /boot/loader/entries/miguel.conf
#arch-chroot /mnt rm .root_disk_uuid

# changing governor to performance
arch-chroot /mnt echo "governor='performance'" >> /mnt/etc/default/cpupower



# enabling and starting DNS resolver via systemd-resolved
arch-chroot /mnt systemctl enable systemd-resolved.service
arch-chroot /mnt systemctl start systemd-resolved.service

