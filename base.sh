#!/bin/bash

pacman -S nano

# set system time
ln -sf /usr/share/zoneinfo/US/Pacific /etc/localtime
hwclock --systohc

echo "find your locale in locale.gen, then uncomment & press ctrl+x, then y, then enter to exit"
echo "starting nano in 10 seconds"
sleep 10s
nano /etc/locale.gen
locale-gen

# set keyboard layout
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
echo "arch" >> /etc/hostname

# set local host address
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 arch.localdomain arch" >> /etc/hosts

# set root password
echo root:password | chpasswd

# install packages for booting
pacman -S grub grub-btrfs efibootmgr

# install packages for network
pacman -S networkmanager network-manager-applet wpa_supplicant

# install DOS filesystem utilities & disk tools
pacman -S mtools dosfstools os-prober

# install shell dialog box, arch mirrorlist
pacman -S dialog reflector

# install linux system group packages
pacman -S base-devel linux-headers

# install user directories & command line tools
pacman -S xdg-user-dirs xdg-utils

# install additional support network & dns packages, service discovery tools
# pacman -S nfs-utils inetutils dnsutils openbsd-netcat iptables-nft ipset nss-mdns avahi

# install bluetooth protocol stack packages
pacman -S bluez bluez-utils

# install support packages & drivers for printers
# pacman -S cups hplip

# install sound system packages
pacman -S alsa-utils pipewire pipewire-alsa pipewire-pulse pipewire-jack pavucontrol

# install SSH protocol support & sync packages
pacman -S openssh rsync

# install support for  battery, power, and thermals
pacman -S acpi acpi_call tlp acpid

# install support for Virtual machines & emulators
# virt-manager qemu qemu-arch-extra edk2-ovmf bridge-utils dnsmasq vde2

# install firewall support
pacman -S firewalld

# install GRUB as bootloader
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

#it didn't work
# install paru
#sudo pacman -S --needed base-devel
#git clone https://aur.archlinux.org/paru.git
#cd paru
#makepkg -si --noconfirm
#cd ..
# install a Nerd Font patched version of JetBrains Mono
#paru -S nerd-fonts-jetbrains-mono

# For Discrete Graphics Cards
# pacman -S --noconfirm xf86-video-amdgpu
# pacman -S --noconfirm nvidia nvidia-utils nvidia-settings

# enable services to always start at system boot
systemctl enable NetworkManager
# systemctl enable bluetooth
# systemctl enable cups.service
systemctl enable sshd
# systemctl enable avahi-daemon
systemctl enable tlp
systemctl enable reflector.timer
systemctl enable fstrim.timer

# enable for virtualization
# systemctl enable libvirtd

systemctl enable firewalld
systemctl enable acpid

# add user and give priviliges
useradd -m rasp
echo rasp:password | chpasswd

# give user ownership for virtualization
# usermod -aG libvirt example-user

echo "rasp ALL=(ALL) ALL" >> /etc/sudoers.d/example-user

# set environment variables to use Wayland
echo "QT_QPA_PLATFORM=wayland" >> /etc/environment
echo "QT_QPA_PLATFORMTHEME=qt5ct" >> /etc/environment
echo "MOZ_ENABLE_WAYLAND=1" >> /etc/environment
echo "MOZ_WEBRENDER=1" >> /etc/environment
echo "XDG_SESSION_TYPE=wayland" >> /etc/environment
echo "XDG_CURRENT_DESKTOP=sway" >> /etc/environment


printf "\e[1;32mDone! Type exit, umount -a and reboot.\e[0m"
