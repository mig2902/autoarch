# Para instalar paquetes AUR
# installing yay
arch-chroot /mnt sudo -u miguel git clone https://aur.archlinux.org/yay.git /home/miguel/yay_tmp_install
arch-chroot /mnt sudo -u miguel /bin/zsh -c "cd /home/miguel/yay_tmp_install && yes | makepkg -si"
arch-chroot /mnt rm -rf /home/miguel/yay_tmp_install

# adding makepkg optimizations
arch-chroot /mnt sed -i -e 's/#MAKEFLAGS="-j2"/MAKEFLAGS=-j'$(nproc --ignore 1)'/' -e 's/-march=x86-64 -mtune=generic/-march=native/' -e 's/xz -c -z/xz -c -z -T '$(nproc --ignore 1)'/' /etc/makepkg.conf
arch-chroot /mnt sed -ie 's/!ccache/ccache/g' /etc/makepkg.conf

# installing various packages from AUR
arch-chroot /mnt sudo -u miguel yay -S i3-gaps --noconfirm
arch-chroot /mnt sudo -u miguel yay -S polybar --noconfirm
arch-chroot /mnt sudo -u miguel yay -S downgrade --noconfirm
arch-chroot /mnt sudo -u miguel yay -S ncspot --noconfirm
arch-chroot /mnt sudo -u miguel yay -S corrupter-bin --noconfirm
arch-chroot /mnt sudo -u miguel yay -S ctop-bin --noconfirm
arch-chroot /mnt sudo -u miguel yay -S whatsapp-nativefier-dark --noconfirm
arch-chroot /mnt sudo -u miguel yay -S simplenote-electron-bin --noconfirm
arch-chroot /mnt sudo -u miguel yay -S picom-tryone-git --noconfirm

# installing better font rendering packages
arch-chroot /mnt sudo -u miguel /bin/zsh -c "yes | yay -S freetype2-infinality-remix fontconfig-infinality-remix cairo-infinality-remix"

# installing oh-my-zsh
arch-chroot /mnt sudo -u miguel curl -O https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh && chmod +x install.sh && RUNZSH=no ./install.sh && rm ./install.sh

# installing pi theme for zsh
arch-chroot /mnt sudo -u miguel /bin/zsh -c "wget -O /home/miguel/.oh-my-zsh/themes/pi.zsh-theme https://raw.githubusercontent.com/tobyjamesthomas/pi/master/pi.zsh-theme"

# installing vundle
arch-chroot /mnt sudo -u miguel mkdir /home/miguel/.vim
arch-chroot /mnt sudo -u miguel mkdir /home/miguel/.vim/bundle
arch-chroot /mnt sudo -u miguel git clone https://github.com/VundleVim/Vundle.vim.git /home/miguel/.vim/bundle/Vundle.vim

# installing fonts
arch-chroot /mnt sudo -u miguel mkdir /home/miguel/fonts_tmp_folder
arch-chroot /mnt sudo -u miguel sudo mkdir /usr/share/fonts/OTF/
# material icons
arch-chroot /mnt sudo -u miguel /bin/zsh -c "cd /home/miguel/fonts_tmp_folder && wget -O materialicons.zip https://github.com/google/material-design-icons/releases/download/3.0.1/material-design-icons-3.0.1.zip && unzip materialicons.zip"
arch-chroot /mnt sudo -u miguel /bin/zsh -c "sudo cp /home/miguel/fonts_tmp_folder/material-design-icons-3.0.1/iconfont/MaterialIcons-Regular.ttf /usr/share/fonts/TTF/"
# removing fonts tmp folder
arch-chroot /mnt sudo -u miguel rm -rf /home/miguel/fonts_tmp_folder

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

# enabling https, http as per default configuration for public zone for firewalld
arch-chroot /mnt systemctl start firewalld.service
arch-chroot /mnt firewall-cmd --add-service=http --permanent
arch-chroot /mnt firewall-cmd --add-service=https --permanent
#arch-chroot /mnt firewall-cmd --change-interface=docker0 --zone=trusted --permanent

# enable firefox accelerated/webrender mode for quantum engine use
arch-chroot /mnt zsh -c 'echo "MOZ_ACCELERATED=1" >> /etc/environment'
arch-chroot /mnt zsh -c 'echo "MOZ_WEBRENDER=1" >> /etc/environment'

# unmounting all mounted partitions
umount -R /mnt

# syncing disks
sync

echo ""
echo "INSTALLATION COMPLETE! enjoy :)"
echo ""

sleep 3
