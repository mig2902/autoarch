
echo "autoarch";

# boot partition size, in MB
boot_partition_size=500

# home partition size, in GB
home_partition_size=40

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
wget -O mirrorlist "https://www.archlinux.org/mirrorlist/?country=DE&country=FR&protocol=https&ip_version=4"
sed -ie 's/^.//g' ./mirrorlist
mv ./mirrorlist /etc/pacman.d/mirrorlist

# updating mirrors
pacman -Syyy

# adding fzf for making disk selection easier
pacman -S fzf --noconfirm

# open dialog for installation type
install_type=$(printf 'UEFI installation (recommended)\nBIOS installation' | fzf | awk '{print $1}')

# open dialog for disk selection
selected_disk=$(sudo fdisk -l | grep 'Disk /dev/' | awk '{print $2,$3,$4}' | sed 's/,$//' | fzf | sed -e 's/\/dev\/\(.*\):/\1/' | awk '{print $1}')  

if [ "${install_type}" == "UEFI" ]; then
    # formatting disk for UEFI install type
    echo "Formatting disk for UEFI install type"
    sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | fdisk /dev/${selected_disk}
      g # gpt partitioning
      n # new partition
        # default: primary partition
        # default: partition 1
      +${boot_partition_size}M # mb on boot partition
        # default: yes if asked
      n # new partition
        # default: primary partition
        # default: partition 2
      +${home_partition_size}G # gb for home partition
        # default: yes if asked
      n # new partition
        # default: primary partition
        # default: partition 3
        # default: all space left of for root partition
        # default: yes if asked
      t # change partition type
      1 # selecting partition 1
      1 # selecting EFI partition type
      w # writing changes to disk
EOF
else
    # formatting disk for BIOS install type
    echo "Formatting disk for BIOS install type"
    sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | fdisk /dev/${selected_disk}
      o # mbr partitioning
      n # new partition
        # default: primary partition
        # default: partition 1
        # default: select first default sector value
      +${boot_partition_size}M # mb on boot partition
        # default: yes if asked
      n # new partition
        # default: primary partition
        # default: partition 2
        # default: select second default sector value
      +${home_partition_size}G # gb for home partition
        # default: yes if asked
      n # new partition
        # default: primary partition
        # default: partition 3
        # default: all space left of for root partition
        # default: yes if asked
      w # writing changes to disk
EOF
fi

# outputting partition changes
fdisk -l /dev/${selected_disk}

# partition filesystem formatting
yes | mkfs.fat -F32 /dev/${selected_disk}1
yes | mkfs.ext4 /dev/${selected_disk}2
yes | mkfs.ext4 /dev/${selected_disk}3

# disk mount
mount /dev/${selected_disk}3 /mnt
mkdir /mnt/boot
mkdir /mnt/home
mount /dev/${selected_disk}1 /mnt/boot
mount /dev/${selected_disk}2 /mnt/home


echo "PRE-INSTALLATION COMPLETE!"
