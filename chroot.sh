#!/bin/bash
# Пароли
root_pass="qwe"
user_pass="qwe"

# Настройка локали и времени
ln -sf /usr/share/zoneinfo/Europe/Saratov /etc/localtime
hwclock --systohc

# Настройка локали
sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
sed -i 's/#ru_RU.UTF-8 UTF-8/ru_RU.UTF-8 UTF-8/' /etc/locale.gen
locale-gen

echo "LANG=ru_RU.UTF-8" > /etc/locale.conf

# Настройка клавиатуры
cat > /etc/vconsole.conf << EOF
KEYMAP=ru
FONT=cyr-sun16
EOF

# Настройка хоста
echo "qwerty" > /etc/hostname

cat > /etc/hosts << EOF
127.0.0.1    localhost
::1          localhost
127.0.1.1    qwerty.localdomain    qwerty
EOF

# Установка паролей
echo "root:$root_pass" | chpasswd

# Создание пользователя
useradd -m -s /bin/bash qwerty
echo "qwerty:$user_pass" | chpasswd
usermod -aG wheel,video,audio,storage,optical,scanner qwerty

# Настройка sudo
sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers

# Включение NetworkManager
systemctl enable NetworkManager

# Установка загрузчика
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

# Очистка
rm /chroot.sh