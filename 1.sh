echo "";
echo "    █████╗ ██╗   ██╗████████╗ ██████╗          █████╗ ██████╗  ██████╗██╗  ██╗";
echo "   ██╔══██╗██║   ██║╚══██╔══╝██╔═══██╗        ██╔══██╗██╔══██╗██╔════╝██║  ██║";
echo "   ███████║██║   ██║   ██║   ██║   ██║ █████╗ ███████║██████╔╝██║     ███████║";
echo "   ██╔══██║██║   ██║   ██║   ██║   ██║ ╚════╝ ██╔══██║██╔══██╗██║     ██╔══██║";
echo "   ██║  ██║╚██████╔╝   ██║   ╚██████╔╝        ██║  ██║██║  ██║╚██████╗██║  ██║";
echo "   ╚═╝  ╚═╝ ╚═════╝    ╚═╝    ╚═════╝         ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝";
echo "                          Archlinux + i3 install script ";


# Disk
selected_disk=/dev/sda

# Partition size, in GB (boot in MB)
boot_partition_size=512
root_partition_size=6
swap_partition_size=1

# Varia
hostname=arch-dell
default_user=miguel
default_passwd=test
kernel=linux-zen
user_groups=audio,lp,optical,storage,video,wheel,games,power,scanner
shell=/bin/bash
wm=i3

# Pacstrap packages
BASE="base base-devel grub networkmanager linux-zen linux-headers linux-firmware git vim nano reflector xorg-server xorg-xinit xdg-user-dirs xorg-xrandr fzf intel-ucode cpupower"
DRIVERS="xf86-video-ati xf86-video-amdgpu mesa libva-mesa-driver mesa-vdpau xf86-input-synaptics"
INTERNET="firefox curl wget netctl wpa_supplicant openssh transmission-gtk transmission-qt telegram-desktop"
MULTIMEDIA="imagemagick vlc ffmpeg pulseaudio pamixer feh playerctl"
UTILITIES="ntfs-3g exfat-utils zip unzip unrar p7zip gvfs gvfs-mtp tree man rofi alacritty hwloc xdotool dunst hsetroot picom dialog"
DOCUMENTS_AND_TEXT="libreoffice-fresh xclip ranger"
FONTS="ttf-dejavu ttf-liberation ttf-inconsolata noto-fonts noto-fonts-emoji ttf-roboto ttf-cascadia-code"
THEMES="papirus-icon-theme"
SECURITY="rsync gnupg"
OTHERS="tmux"
DEVELOPER="code python go"
CUSTOM=""

################################################################################
set -e

echo ""
echo -e "\e[1;42m>>> START INSTALLATION...\e[0m"
echo ""
sleep 3

# Syncing system datetime
timedatectl set-ntp true

# Reflector is a script which can retrieve the latest mirror list from the MirrorStatus page,
# filter the most up-to-date mirrors, sort them by speed and overwrite the file /etc/pacman.d/mirrorlist.
pacman -S reflector --noconfirm

# Back up the existing /etc/pacman.d/mirrorlist:
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup

# Select the HTTPS mirrors synchronized within the last 12 hours and located in either France or Germany,
# sort them by download speed, and overwrite the file /etc/pacman.d/mirrorlist:
reflector --country France --country Germany --age 12 --protocol https --sort rate --save /etc/pacman.d/mirrorlist

# Updating mirrors
pacman -Syyy

# Adding fzf for making disk selection easier
pacman -S fzf --noconfirm

# Formatting disk for BIOS system
echo "Formatting disk for BIOS install type"
sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | fdisk ${selected_disk}
  o # mbr partitioning
  n # new partition
    # default: primary partition
    # default: partition 1
    # default: yes if asked
  +${boot_partition_size}M # mb for boot partition
  y # default: yes if asked

  n # new partition
    # default: primary partition
    # default: partition 2
    # default: yes if asked
  +${root_partition_size}G # gb for root partition
    # default: yes if asked

  n # new partition
    # default: primary partition
    # default: partition 3
    # default: yes if asked
  +${swap_partition_size}G # gb for swap partition
  t # change partition type
  3 # selecting partition 3
 82 # selecting swap partition type
    # default: yes if asked

  n # new partition
  p # select primary partition
    # default: partition 4
    # default: all space left of for home partition
    # default: yes if asked
  a # select bootable partition
  1 # select partition 1
  w # writing changes to disk
EOF

# Outputting partition changes
fdisk -l ${selected_disk}

# Partition filesystem formatting
yes | mkfs.ext2 ${selected_disk}1
yes | mkfs.ext4 ${selected_disk}2
yes | mkswap ${selected_disk}3
yes | swapon ${selected_disk}3
yes | mkfs.ext4 ${selected_disk}4

# Disk mount
mount ${selected_disk}2 /mnt
mkdir /mnt/boot
mkdir /mnt/home
mount ${selected_disk}1 /mnt/boot
mount ${selected_disk}4 /mnt/home

echo ""
echo -e "\e[1;42m>>> PRE-INSTALLATION COMPLETE...\e[0m"
echo ""
sleep 3
