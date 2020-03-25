# generating fstab
genfstab -U /mnt >> /mnt/etc/fstab

# enabled [multilib] repo on installed system
arch-chroot /mnt zsh -c 'echo "[multilib]" >> /etc/pacman.conf'
arch-chroot /mnt zsh -c 'echo "Include = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf'

# updating repo status
arch-chroot /mnt pacman -Syyy

# setting right timezone
arch-chroot /mnt ln -sf /usr/share/zoneinfo/Europe/Madrid /etc/localtime

# enabling font presets for better font rendering
arch-chroot /mnt ln -s /etc/fonts/conf.avail/70-no-bitmaps.conf /etc/fonts/conf.d
arch-chroot /mnt ln -s /etc/fonts/conf.avail/10-sub-pixel-rgb.conf /etc/fonts/conf.d
arch-chroot /mnt ln -s /etc/fonts/conf.avail/11-lcdfilter-default.conf /etc/fonts/conf.d

# synchronizing timer
arch-chroot /mnt hwclock --systohc

# localizing system
arch-chroot /mnt sed -ie 's/#es_ES.UTF-8 UTF-8/es_ES.UTF-8 UTF-8/g' /etc/locale.gen
arch-chroot /mnt sed -ie 's/#es_ES ISO-8859-1/es_ES ISO-8859-1/g' /etc/locale.gen
arch-chroot /mnt sed -ie 's/#es_ES@euro ISO-8859-15/es_ES@euro ISO-8859-15/g' /etc/locale.gen

# generating locale
arch-chroot /mnt locale-gen

# setting system language
arch-chroot /mnt echo "LANG=es_ES.UTF-8" >> /mnt/etc/locale.conf

# setting machine name
arch-chroot /mnt echo "arch-laptop" >> /mnt/etc/hostname
# Choose machine name
#arch-chroot /mnt read -p "Choose your machine name (only one word):" machine_name

# setting hosts file
arch-chroot /mnt echo "127.0.0.1 localhost" >> /mnt/etc/hosts
arch-chroot /mnt echo "::1 localhost" >> /mnt/etc/hosts
arch-chroot /mnt echo "127.0.1.1 arch-laptop.localdomain arch-laptop" >> /mnt/etc/hosts

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
