echo "";
echo "";
echo "  /$$$$$$              /$$                          /$$$$$$                      /$$";      
echo " /$$__  $$            | $$                  /$$    /$$__  $$                    | $$";      
echo "| $$  \ $$ /$$   /$$ /$$$$$$    /$$$$$$    | $$   | $$  \ $$  /$$$$$$   /$$$$$$$| $$$$$$$"; 
echo "| $$$$$$$$| $$  | $$|_  $$_/   /$$__  $$ /$$$$$$$$| $$$$$$$$ /$$__  $$ /$$_____/| $$__  $$";
echo "| $$__  $$| $$  | $$  | $$    | $$  \ $$|__  $$__/| $$__  $$| $$  \__/| $$      | $$  \ $$";
echo "| $$  | $$| $$  | $$  | $$ /$$| $$  | $$   | $$   | $$  | $$| $$      | $$      | $$  | $$";
echo "| $$  | $$|  $$$$$$/  |  $$$$/|  $$$$$$/   |__/   | $$  | $$| $$      |  $$$$$$$| $$  | $$";
echo "|__/  |__/ \______/    \___/   \______/           |__/  |__/|__/       \_______/|__/  |__/";
echo "";                                                                                     
echo "     						  Archlinux + i3 install script ";
echo "";                                                                                     
                                                                                      
# disk
selected_disk=sda

# root partition size, in GB
root_partition_size=45

# pacstrap packages
BASE="base base-devel grub networkmanager linux-zen linux-headers linux-firmware git xorg-server xorg-xinit xdg-user-dirs xorg-xrandr fzf intel-ucode cpupower"
DRIVERS="xf86-video-ati xf86-video-amdgpu mesa libva-mesa-driver mesa-vdpau xf86-input-synaptics"
INTERNET="firefox curl wget netctl wpa_supplicant openssh transmission-gtk transmission-qt telegram-desktop"
MULTIMEDIA="imagemagick vlc ffmpeg pulseaudio pamixer feh playerctl"
UTILITIES="ntfs-3g exfat-utils zip unzip unrar p7zip gvfs gvfs-mtp tree man rofi alacritty hwloc xdotool dunst hsetroot picom dialog"
DOCUMENTS_AND_TEXT="libreoffice-fresh vim xclip ranger"
FONTS="ttf-dejavu ttf-liberation ttf-inconsolata noto-fonts noto-fonts-emoji ttf-roboto ttf-cascadia-code"
THEMES="papirus-icon-theme"
SECURITY="rsync gnupg"
SCIENCE=""
OTHERS="tmux"
DEVELOPER="code python"
CUSTOM=""

# hostname
hostname=arch-dell

ROOT_PASSWORD="test" # Main root password. Warning: change it!
USER_PASSWORD="test" # Main user password. Warning: change it!

echo ""
echo -e "\e[1;42m>>> START INSTALLATION...\e[0m"
echo ""

sleep 5

# syncing system datetime
timedatectl set-ntp true

# getting latest mirrors for france and germany
wget -O mirrorlist "https://www.archlinux.org/mirrorlist/?country=FR&country=DE&protocol=https&ip_version=4"
sed -ie 's/^.//g' ./mirrorlist
mv ./mirrorlist /etc/pacman.d/mirrorlist

# updating mirrors
pacman -Syyy

# adding fzf for making disk selection easier
pacman -S fzf --noconfirm

# formatting disk for BIOS install
echo "Formatting disk for BIOS install type"
sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | fdisk /dev/${selected_disk}
  o # mbr partitioning
  n # new partition
    # default: primary partition
    # default: partition 1
    # default: yes if asked
  +${root_partition_size}G # gb on root partition
    # default: yes if asked
  n # new partition
    # default: primary partition
    # default: partition 2
    # default: all space left of for home partition
    # default: yes if asked
  a # select bootable partition
  1 # select partition 1
  w # writing changes to disk
EOF

# outputting partition changes
fdisk -l /dev/${selected_disk}

# partition filesystem formatting
yes | mkfs.ext4 /dev/${selected_disk}1
yes | mkfs.ext4 /dev/${selected_disk}2

# disk mount
mount /dev/${selected_disk}1 /mnt
mkdir /mnt/boot
mkdir /mnt/home
mount /dev/${selected_disk}1 /mnt/boot
mount /dev/${selected_disk}2 /mnt/home

echo ""
echo -e "\e[1;42m>>> PRE-INSTALLATION COMPLETE...\e[0m"
echo ""

sleep 5

# Driver para Ati radeon y kernel linux-zen
# pacstrap-ping desired disk
pacstrap /mnt ${BASE} ${DRIVERS} ${INTERNET} ${MULTIMEDIA} ${UTILITIES} \
#${DOCUMENTS AND TEXT} ${FONTS} ${THEMES} ${SECURITY} ${SCIENCE} ${OTHERS} ${DEVELOPER}
 
echo ""
echo -e "\e[1;42m>>> PACSTRAP INSTALLATION COMPLETE...\e[0m"
echo ""

sleep 5

# generating fstab
genfstab -U /mnt >> /mnt/etc/fstab

# enter base system
#arch-chroot /mnt

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

# hacer persistente lenguaje consola
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
echo -e "\e[1;42m>>> BASE SYSTEM SETTINGS COMPLETE...\e[0m"
echo ""

sleep 5



echo ""
echo -e "\e[1;42m>>> SETTING USERS AND SERVICES...\e[0m"
echo ""

sleep 5

# making sudoers do sudo stuff without requiring password typing
arch-chroot /mnt sed -ie 's/# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/g' /etc/sudoers

# make initframs
#arch-chroot /mnt mkinitcpio -p linux
arch-chroot /mnt mkinitcpio -p linux-zen

# setting root password
arch-chroot /mnt sudo -u root /bin/bash -c 'echo "Insert root password: " && read root_password && echo -e "$root_password\n$root_password" | passwd root'




# making user miguel
arch-chroot /mnt useradd -m -G wheel -s /bin/bash miguel

# setting user miguel password
arch-chroot /mnt sudo -u root /bin/bash -c 'echo "Insert miguel password: " && read miguel_password && echo -e "$miguel_password\n$miguel_password" | passwd miguel'

# instalar grub
#grub-install /dev/sda
arch-chroot /mnt grub-install --root-directory=/mnt /dev/sda

# actualizar grub
arch-chroot /mnt /bin/bash
arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg


# making services start at boot
arch-chroot /mnt systemctl enable cpupower.service
arch-chroot /mnt systemctl enable NetworkManager.service


# making i3 default for startx for both root and miguel
arch-chroot /mnt echo "exec i3" >> /mnt/root/.xinitrc
arch-chroot /mnt echo "exec i3" >> /mnt/home/miguel/.xinitrc


echo ""
echo -e "\e[1;42m>>> AUR PACKAGES INSTALLATION...\e[0m"
echo ""

sleep 5

# Para instalar paquetes AUR
# installing yay
arch-chroot /mnt sudo -u miguel git clone https://aur.archlinux.org/yay-git.git /home/miguel/yay_tmp_install
arch-chroot /mnt sudo -u miguel /bin/bash -c "cd /home/miguel/yay_tmp_install && yes | makepkg -si"
arch-chroot /mnt rm -rf /home/miguel/yay_tmp_install

# adding makepkg optimizations
arch-chroot /mnt sed -i -e 's/#MAKEFLAGS="-j2"/MAKEFLAGS=-j'$(nproc --ignore 1)'/' -e 's/-march=x86-64 -mtune=generic/-march=native/' -e 's/xz -c -z/xz -c -z -T '$(nproc --ignore 1)'/' /etc/makepkg.conf
arch-chroot /mnt sed -ie 's/!ccache/ccache/g' /etc/makepkg.conf

# installing various packages from AUR
arch-chroot /mnt sudo -u miguel yay -S i3-gaps --noconfirm
arch-chroot /mnt sudo -u miguel yay -S polybar --noconfirm
arch-chroot /mnt sudo -u miguel yay -S corrupter-bin --noconfirm
arch-chroot /mnt sudo -u miguel yay -S whatsapp-nativefier-dark --noconfirm
arch-chroot /mnt sudo -u miguel yay -S simplenote-electron-bin --noconfirm
#arch-chroot /mnt sudo -u miguel yay -S picom-tryone-git --noconfirm

# installing better font rendering packages
arch-chroot /mnt sudo -u miguel /bin/bash -c "yes | yay -S freetype2-infinality-remix fontconfig-infinality-remix cairo-infinality-remix"

# installing vundle
arch-chroot /mnt sudo -u miguel mkdir /home/miguel/.vim
arch-chroot /mnt sudo -u miguel mkdir /home/miguel/.vim/bundle
arch-chroot /mnt sudo -u miguel git clone https://github.com/VundleVim/Vundle.vim.git /home/miguel/.vim/bundle/Vundle.vim

# material icons
arch-chroot /mnt sudo -u miguel /bin/bash -c "cd /home/miguel/fonts_tmp_folder && wget -O materialicons.zip https://github.com/google/material-design-icons/releases/download/3.0.1/material-design-icons-3.0.1.zip && unzip materialicons.zip"
arch-chroot /mnt sudo -u miguel /bin/bash -c "sudo cp /home/miguel/fonts_tmp_folder/material-design-icons-3.0.1/iconfont/MaterialIcons-Regular.ttf /usr/share/fonts/TTF/"

# installing fonts
arch-chroot /mnt sudo -u miguel mkdir /home/miguel/fonts_tmp_folder
arch-chroot /mnt sudo -u miguel sudo mkdir /usr/share/fonts/OTF/

# removing fonts tmp folder
arch-chroot /mnt sudo -u miguel rm -rf /home/miguel/fonts_tmp_folder

# installing config files
arch-chroot /mnt sudo -u miguel mkdir /home/miguel/GitHub
arch-chroot /mnt sudo -u miguel git clone https://github.com/mig2902/autoarch.git /home/miguel/GitHub/autoarch
arch-chroot /mnt sudo -u miguel /bin/bash -c "chmod 700 /home/miguel/GitHub/autoarch/install_configs.sh"
arch-chroot /mnt sudo -u miguel /bin/bash -c "cd /home/miguel/GitHub/autoarch && ./install_configs.sh"

echo ""
echo -e "\e[1;42m>>> AUR PACKAGES INSTALLATION COMPLETE...\e[0m"
echo ""

sleep 5



# unmounting all mounted partitions
umount -R /mnt

# syncing disks
sync

echo ""
echo -e "\e[1;42m>>> INSTALLATION COMPLETE...\e[0m"
echo ""

sleep 5

reboot



