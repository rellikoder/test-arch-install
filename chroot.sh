#!/bin/bash
ln -sf /usr/share/zoneinfo/Europe/Saratov /etc/localtime
hwclock --systohc

sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
sed -i 's/#ru_RU.UTF-8 UTF-8/ru_RU.UTF-8 UTF-8/' /etc/locale.gen
locale-gen

echo "LANG=ru_RU.UTF-8" > /etc/locale.conf

cat > /etc/vconsole.conf << EOF
KEYMAP=ru
FONT=cyr-sun16
EOF

echo "qwerty" > /etc/hostname

cat > /etc/hosts << EOF
127.0.0.1    localhost
::1          localhost
127.0.1.1    qwerty.localdomain    qwerty
EOF

echo "Введите пароль для root:"
read -s root_pass
echo "root:$root_pass" | chpasswd

useradd -m -s /bin/bash qwerty
echo "Введите пароль для пользователя qwerty:"
read -s user_pass
echo "qwerty:$user_pass" | chpasswd

usermod -aG wheel,video,audio,storage,optical,scanner qwerty

#remove
pacman -S sudo networkmanager

sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers

systemctl enable NetworkManager