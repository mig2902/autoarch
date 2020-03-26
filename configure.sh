# enabled [multilib] repo on installed system
arch-chroot /mnt zsh -c 'echo "[multilib]" >> /etc/pacman.conf'
arch-chroot /mnt zsh -c 'echo "Include = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf'

# updating repo status
arch-chroot /mnt pacman -Syyy





# making sudoers do sudo stuff without requiring password typing
arch-chroot /mnt sed -ie 's/# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/g' /etc/sudoers

# make initframs
#arch-chroot /mnt mkinitcpio -p linux
arch-chroot /mnt mkinitcpio -p linux-zen

# setting root password
arch-chroot /mnt sudo -u root /bin/zsh -c 'echo "Insert root password: " && read root_password && echo -e "$root_password\n$root_password" | passwd root'

# making user miguel
arch-chroot /mnt useradd -m -G wheel -s /bin/zsh miguel

# setting user miguel password
arch-chroot /mnt sudo -u root /bin/zsh -c 'echo "Insert miguel password: " && read miguel_password && echo -e "$miguel_password\n$miguel_password" | passwd miguel'

# UEFI
# installing systemd-boot
#bootctl --path=/boot install

# instalar grub
#grub-install /dev/sda
grub-install --root-directory=/mnt /dev/sda

# actualizar grub
arch-chroot /mnt /bin/bash
grub-mkconfig -o /boot/grub/grub.cfg
