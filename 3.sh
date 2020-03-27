# hostname
hostname=arch-dell

echo ""
echo -e "\e[1;42m>>> START CONFIGURING SYSTEM SETTINGS...\e[0m"
echo ""
sleep 3

# Generating fstab
genfstab -U /mnt >> /mnt/etc/fstab

# Change root into the new system
arch-chroot /mnt

# setting machine name
arch-chroot /mnt echo ${hostname} >> /mnt/etc/hostname

# setting right timezone
arch-chroot /mnt ln -sf /usr/share/zoneinfo/Europe/Madrid /etc/localtime

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

# setting permanent language
arch-chroot /mnt echo KEYMAP=es > /etc/vconsole.conf

# setting hosts file
arch-chroot /mnt echo "127.0.0.1 localhost" >> /mnt/etc/hosts
arch-chroot /mnt echo "::1 localhost" >> /mnt/etc/hosts
arch-chroot /mnt echo "127.0.1.1 ${hostname}.localdomain ${hostname}" >> /mnt/etc/hosts

# enabling font presets for better font rendering
arch-chroot /mnt ln -s /etc/fonts/conf.avail/70-no-bitmaps.conf /etc/fonts/conf.d
arch-chroot /mnt ln -s /etc/fonts/conf.avail/10-sub-pixel-rgb.conf /etc/fonts/conf.d
arch-chroot /mnt ln -s /etc/fonts/conf.avail/11-lcdfilter-default.conf /etc/fonts/conf.d

echo ""
echo -e "\e[1;42m>>> SYSTEM SETTINGS COMPLETE...\e[0m"
echo ""
sleep 3
