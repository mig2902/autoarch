set -e

default_user=miguel
default_passwd=test
kernel=linux-zen
user_groups=audio,lp,optical,storage,video,wheel,games,power,scanner
shell=/bin/bash

selected_disk=/dev/sda
wm=i3

echo ""
echo -e "\e[1;42m>>> SETTING USERS AND SERVICES...\e[0m"
echo ""
sleep 3

# Making sudoers do sudo stuff without requiring password typing
arch-chroot /mnt sed -ie 's/# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/g' /etc/sudoers

# Make initframs
arch-chroot /mnt mkinitcpio -p ${kernel}



# setting root password
arch-chroot /mnt sudo -u root ${shell} -c 'echo "Insert root password: " && read root_password && echo -e "$root_password\n$root_password" | passwd root'

# making user miguel
arch-chroot /mnt useradd -m -G wheel -s ${shell} miguel

# setting user miguel password
arch-chroot /mnt sudo -u root ${shell} -c 'echo "Insert miguel password: " && read miguel_password && echo -e "$miguel_password\n$miguel_password" | passwd miguel'







# Setting root password
arch-chroot /mnt sudo -u root ${shell} -c echo -e "${default_passwd}\n${default_passwd}" | passwd

# Add user
arch-chroot /mnt useradd -m -g users -G ${user_groups} -s ${shell} ${default_user}

# Setting user password
#arch-chroot /mnt sudo -u root /bin/bash -c 'echo "Insert miguel password: " && read miguel_password && echo -e "$miguel_password\n$miguel_password" | passwd miguel'
echo -e "${default_passwd}\n${default_passwd}" | passwd ${default_user}

# Install grub
#grub-install /dev/sda
#arch-chroot /mnt grub-install --root-directory=/mnt /dev/sda

# Installing grub bootloader
arch-chroot /mnt grub-install ${selected_disk}

# Update grub
#arch-chroot /mnt ${shell}
#arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg

# Making grub auto config
arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg

# Making services start at boot
arch-chroot /mnt systemctl enable cpupower.service
arch-chroot /mnt systemctl enable NetworkManager.service

# Making i3 default for startx for both root and user
arch-chroot /mnt echo "exec ${wm}" >> /mnt/root/.xinitrc
arch-chroot /mnt echo "exec ${wm}" >> /mnt/home/${default_user}/.xinitrc

echo ""
echo -e "\e[1;42m>>> USERS AND SERVICES SETTINGS COMPLETE...\e[0m"
echo ""
sleep 3
