
echo "autoarch";

# root partition size, in GB
root_partition_size=45

# checks wheter there is multilib repo enabled properly or not
IS_MULTILIB_REPO_DISABLED=$(cat /etc/pacman.conf | grep "#\[multilib\]" | wc -l)
if [ "$IS_MULTILIB_REPO_DISABLED" == "1" ]
then
    echo "You need to enable [multilib] repository inside /etc/pacman.conf file before running this script, aborting installation"
    exit -1
fi
echo "[multilib] repo correctly enabled, continuing"

# syncing system datetime
timedatectl set-ntp true

## Se puede usar reflector al finalizar la instalacion o buscar por velocidad
# getting latest mirrors for france and germany
wget -O mirrorlist "https://www.archlinux.org/mirrorlist/?country=FR&country=DE&protocol=https&ip_version=4"
sed -ie 's/^.//g' ./mirrorlist
mv ./mirrorlist /etc/pacman.d/mirrorlist

# updating mirrors
pacman -Syyy

# adding fzf for making disk selection easier
pacman -S fzf --noconfirm

# open dialog for disk selection
selected_disk=$(sudo fdisk -l | grep 'Disk /dev/' | awk '{print $2,$3,$4}' | sed 's/,$//' | fzf | sed -e 's/\/dev\/\(.*\):/\1/' | awk '{print $1}')  

#echo "Formatting disk for BIOS install"
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
echo -e "\e[1;42mPRE-INSTALLATION COMPLETE...\e[0m"
echo ""

sleep 3
