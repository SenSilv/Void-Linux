#!/bin/bash

## Configure Firewall
echo '94.140.14.14' >> /etc/resolv.conf.head

iptables -X
iptables -F

iptables INPUT DROP
iptables OUTPUT DROP
iptables FORWARD DROP

iptables -A OUTPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j ACCEPT
iptables -A OUTPUT -p udp --dport 53 -d 94.140.14.14 -j ACCEPT

ln -s /etc/sv/iptables /var/service/iptables/
sv restart /var/service/iptables

## Update System
xbps-install -Suy

xbps-install xorg-minimal i3-gaps xf86-video-nouveau alsa-utils apparmor st firefox noto-fonts-cjk nano

## Enable apparmor for all profiles
sudo aa-enforce /etc/apparmor.d/*

# i3-gaps config
echo 'exec i3' >> /home/.xinitrc
echo 'gaps inner 8' >> /home/admin/.config/i3/config
echo 'gaps outer 8' >> /home/admin/.config/i3/config

## Up services on boot
# Enable ufw on boot
ln -s /etc/sv/ufw /var/service/
sv up /var/service/ufw

# Enable i3 on boot
ln -s /etc/sv/i3 /var/service/
sv up /var/service/i3

cp /home/admin/backup/etc /etc

# Hardening the directory
chmod og-rwx /home/admin

#echo 'b08dfa6083e7567a1921a715000001fb' >> /var/lib/dbus/machine-id
echo 'proc /proc proc nosuid,nodev,noexec,hidepid=2,gid=proc 0 0' >> /etc/fstab
echo 'umask 0077' >> /etc/profile

cp /home/admin/backup/securetty /etc/securetty

## Font rendering
ln -s /usr/share/fontconfig/conf.avail/70-no-bitmaps.conf /etc/fonts/conf.d/
xbps-reconfigure -f fontconfig
