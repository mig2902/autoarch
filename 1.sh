echo "";
echo " █████╗ ██╗   ██╗████████╗ ██████╗        █████╗ ██████╗  ██████╗██╗  ██╗";
echo "██╔══██╗██║   ██║╚══██╔══╝██╔═══██╗      ██╔══██╗██╔══██╗██╔════╝██║  ██║";
echo "███████║██║   ██║   ██║   ██║   ██║█████╗███████║██████╔╝██║     ███████║";
echo "██╔══██║██║   ██║   ██║   ██║   ██║╚════╝██╔══██║██╔══██╗██║     ██╔══██║";
echo "██║  ██║╚██████╔╝   ██║   ╚██████╔╝      ██║  ██║██║  ██║╚██████╗██║  ██║";
echo "╚═╝  ╚═╝ ╚═════╝    ╚═╝    ╚═════╝       ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝";
echo "                      Archlinux + i3 install script ";


# disk
selected_disk=sda

# partition size, in GB (boot in MB)
boot_partition=512
root_partition_size=45
swap_partition_size=1

echo ""
echo -e "\e[1;42m>>> START INSTALLATION...\e[0m"
echo ""
sleep 5

# Syncing system datetime
timedatectl set-ntp true

# Reflector is a script which can retrieve the latest mirror list from the MirrorStatus page,
# filter the most up-to-date mirrors, sort them by speed and overwrite the file /etc/pacman.d/mirrorlist.
sudo pacman -S reflector

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
sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | fdisk /dev/${selected_disk}
  o # mbr partitioning
  n # new partition
    # default: primary partition
    # default: partition 1
    # default: yes if asked
  +${boot_partition_size}M # mb for boot partition
    # default: yes if asked

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
fdisk -l /dev/${selected_disk}

# Partition filesystem formatting
yes | mkfs.ext2 /dev/${selected_disk}1
yes | mkfs.ext4 /dev/${selected_disk}2
yes | mkfswap /dev/${selected_disk}3
yes | swapon /dev/${selected_disk}3
yes | mkfs.ext4 /dev/${selected_disk}4

# Disk mount
mount /dev/${selected_disk}2 /mnt
mkdir /mnt/boot
mkdir /mnt/home
mount /dev/${selected_disk}1 /mnt/boot
mount /dev/${selected_disk}4 /mnt/home

echo ""
echo -e "\e[1;42m>>> PRE-INSTALLATION COMPLETE...\e[0m"
echo ""
sleep 5
