# installing oh-my-zsh
arch-chroot /mnt sudo -u miguel curl -O https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh && chmod +x install.sh && RUNZSH=no ./install.sh && rm ./install.sh

# installing pi theme for zsh
arch-chroot /mnt sudo -u miguel /bin/zsh -c "wget -O /home/miguel/.oh-my-zsh/themes/pi.zsh-theme https://raw.githubusercontent.com/tobyjamesthomas/pi/master/pi.zsh-theme"







# installing config files
arch-chroot /mnt sudo -u miguel mkdir /home/miguel/GitHub
arch-chroot /mnt sudo -u miguel git clone https://github.com/mig2902/autoarch.git /home/miguel/GitHub/autoarch
arch-chroot /mnt sudo -u miguel /bin/zsh -c "chmod 700 /home/miguel/GitHub/autoarch/install_configs.sh"
arch-chroot /mnt sudo -u miguel /bin/zsh -c "cd /home/miguel/GitHub/autoarch && ./install_configs.sh"

# create folder for screenshots
arch-chroot /mnt sudo -u miguel mkdir /home/miguel/Screenshots

# create pictures folder, secrets folder and moving default wallpaper
arch-chroot /mnt sudo -u miguel mkdir /home/miguel/Pictures/

#arch-chroot /mnt sudo -u miguel mkdir /home/miguel/.secrets/
arch-chroot /mnt sudo -u miguel mkdir /home/miguel/Pictures/wallpapers/

# enable features on /etc/pacman.conf file
arch-chroot /mnt sed -ie 's/#UseSyslog/UseSyslog/g' /etc/pacman.conf
arch-chroot /mnt sed -ie 's/#Color/Color/g' /etc/pacman.conf
arch-chroot /mnt sed -ie 's/#TotalDownload/TotalDownload/g' /etc/pacman.conf
arch-chroot /mnt sed -ie 's/#VerbosePkgLists/VerbosePkgLists/g' /etc/pacman.conf




