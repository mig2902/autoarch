
echo "autoarch";

# disk
selected_disk=sda

# root partition size, in GB
root_partition_size=45



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
echo -e "\e[1;42m>>>PRE-INSTALLATION COMPLETE...\e[0m"
echo ""

sleep 5

# Driver para Ati radeon y kernel linux-zen
# pacstrap-ping desired disk
pacstrap /mnt base base-devel vim grub networkmanager rofi feh linux-zen linux-headers \
ntfs-3g alacritty git zsh intel-ucode cpupower xf86-video-ati xf86-video-amdgpu vlc \
xorg-server xorg-xinit ttf-dejavu ttf-liberation ttf-inconsolata noto-fonts \
firefox code zip unzip unrar \
pulseaudio pamixer telegram-desktop python python-pip wget \
openssh xorg-xrandr noto-fonts-emoji imagemagick xclip light ranger \
ttf-roboto playerctl papirus-icon-theme hwloc p7zip picom hsetroot \
nemo linux-firmware tree man ttf-cascadia-code fzf \
mesa libva-mesa-driver \
mesa-vdpau lib32-mesa-vdpau zsh-syntax-highlighting xdotool cronie dunst entr \
xf86-video-vmware python-dbus

echo ""
echo -e "\e[1;42m>>>PACSTRAP INSTALLATION COMPLETE...\e[0m"
echo ""

sleep 5
