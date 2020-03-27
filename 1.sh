echo "";
echo " █████╗ ██╗   ██╗████████╗ ██████╗        █████╗ ██████╗  ██████╗██╗  ██╗";
echo "██╔══██╗██║   ██║╚══██╔══╝██╔═══██╗      ██╔══██╗██╔══██╗██╔════╝██║  ██║";
echo "███████║██║   ██║   ██║   ██║   ██║█████╗███████║██████╔╝██║     ███████║";
echo "██╔══██║██║   ██║   ██║   ██║   ██║╚════╝██╔══██║██╔══██╗██║     ██╔══██║";
echo "██║  ██║╚██████╔╝   ██║   ╚██████╔╝      ██║  ██║██║  ██║╚██████╗██║  ██║";
echo "╚═╝  ╚═╝ ╚═════╝    ╚═╝    ╚═════╝       ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝";
echo "                      Archlinux + i3 install script ";



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
