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
DEVELOPER="code python go"
CUSTOM=""

# Pacstrap: install the base package, Linux kernel and firmware for common hardware
pacstrap /mnt ${BASE} ${DRIVERS} ${INTERNET} #${MULTIMEDIA} ${UTILITIES} \
#${DOCUMENTS AND TEXT} ${FONTS} ${THEMES} ${SECURITY} ${SCIENCE} ${OTHERS} ${DEVELOPER}

echo ""
echo -e "\e[1;42m>>> PACSTRAP INSTALLATION COMPLETE...\e[0m"
echo ""
sleep 5
