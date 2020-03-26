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
BASE="base base-devel grub networkmanager linux-zen linux-headers linux-firmware xorg-server xorg-xinit xdg-user-dirs xorg-xrandr fzf intel-ucode cpupower"
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
DEVELOPER="code python git"
CUSTOM=""

# hostname
hostname=arch-dell

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

# instalar grub
grub-install /dev/sda
#grub-install --root-directory=/mnt /dev/sda

# actualizar grub
#arch-chroot /mnt /bin/bash
grub-mkconfig -o /boot/grub/grub.cfg


# making services start at boot
arch-chroot /mnt systemctl enable cpupower.service
arch-chroot /mnt systemctl enable NetworkManager.service


# making i3 default for startx for both root and miguel
arch-chroot /mnt echo "exec i3" >> /mnt/root/.xinitrc
arch-chroot /mnt echo "exec i3" >> /mnt/home/miguel/.xinitrc

















