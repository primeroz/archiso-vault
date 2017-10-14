#!/bin/bash

set -e -u

sed -i 's/#\(en_US\.UTF-8\)/\1/' /etc/locale.gen
locale-gen en_US.UTF-8

ln -sf /usr/share/zoneinfo/UTC /etc/localtime

usermod -s /usr/bin/zsh root
cp -aT /etc/skel/ /root/
chmod 700 /root

# Create live user
groupadd live
useradd -d /home/live -s /usr/bin/zsh -g live -G wheel,network,video,audio,storage,power -m  live
chpasswd --encrypted <<<'live:$6$rio2ufsfj$kVVP6QHywhzK87jzeBrzM7DLXdm1AkHyQvlj7cM3sdup0.ZYig/UL15D.DrQ.U8fDFvugpryIoDRvjOfjKkSx/'

echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Disable autologin
rm /etc/systemd/system/getty@tty1.service.d/autologin.conf

sed -i 's/#\(PermitRootLogin \).\+/\1yes/' /etc/ssh/sshd_config
sed -i "s/#Server/Server/g" /etc/pacman.d/mirrorlist
sed -i 's/#\(Storage=\)auto/\1volatile/' /etc/systemd/journald.conf

sed -i 's/#\(HandleSuspendKey=\)suspend/\1ignore/' /etc/systemd/logind.conf
sed -i 's/#\(HandleHibernateKey=\)hibernate/\1ignore/' /etc/systemd/logind.conf
sed -i 's/#\(HandleLidSwitch=\)suspend/\1ignore/' /etc/systemd/logind.conf

#systemctl enable pacman-init.service choose-mirror.service
#systemctl set-default multi-user.target

rm /usr/share/xsessions/openbox-kde.desktop

echo 'setxkbmap -layout "gb"' > /home/live/.xinitrc
echo 'exec $1' >> /home/live/.xinitrc
chown live:live /home/live/.xinitrc

mmaker openbox3

#sed -i 's/^.*current_theme.*/current_theme flat/' /etc/slim.conf

systemctl enable slim.service
systemctl set-default graphical.target
