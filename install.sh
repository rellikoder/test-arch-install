#!/bin/bash
# Переменные
disk="/dev/sda"

# Диск
wipefs --all $disk
parted -s $disk mklabel gpt
parted -s $disk mkpart '"EFI System"' fat32 1MiB 513MiB
parted -s $disk set 1 esp on
parted -s $disk mkpart '"Linux swap"' linux-swap 513MiB 16897MiB 
parted -s $disk mkpart '"Linux filesystem"' ext4 16897MiB 100%
mkfs.fat -F32 "${disk}1"
mkswap "${disk}2"
swapon "${disk}2"
mkfs.ext4 -F "${disk}3"

# Монтирование
mount ${disk}3 /mnt
mkdir /mnt/boot

# Смена зеркал
cat > /etc/pacman.d/mirrorlist << 'EOF'
## Russia
Server = https://archlinux.gay/archlinux/$repo/os/$arch
Server = https://ru.mirrors.cicku.me/archlinux/$repo/os/$arch
Server = https://mirror.kamtv.ru/archlinux/$repo/os/$arch
Server = https://mirror.kpfu.ru/archlinux/$repo/os/$arch
Server = https://mirror.nw-sys.ru/archlinux/$repo/os/$arch
Server = https://repository.su/archlinux/$repo/os/$arch
Server = https://web.sketserv.ru/archlinux/$repo/os/$arch
Server = https://mirror2.sl-chat.ru/archlinux/$repo/os/$arch
Server = https://mirror3.sl-chat.ru/archlinux/$repo/os/$arch
Server = https://mirror.truenetwork.ru/archlinux/$repo/os/$arch
Server = https://vladivostokst.ru/archlinux/$repo/os/$arch
Server = https://mirror.yandex.ru/archlinux/$repo/os/$arch
EOF

# Установка
pacstrap /mnt base base-devel linux linux-firmware sudo networkmanager

bash ./setup.sh