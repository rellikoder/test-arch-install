#!/bin/bash
# Переменные
disk="/dev/sda"
swap="16384"
filesystem=$((swap + 513))

# Диск
wipefs --all $disk

parted -s $disk mklabel gpt
parted -s $disk mkpart "EFI System" fat32 1MiB 513MiB
parted -s $disk set 1 esp on
parted -s $disk mkpart "Linux swap" linux-swap 513Mib ${filesystem}MiB 
parted -s $disk mkpart "Linux filesystem" ext4 ${filesystem}Mib 100%

mkfs.fat -F32 "${disk}1"
mkswap "${disk}2"
swapon "${disk}2"
mkfs.ext4 "${disk}3"

echo "Разделы созданы:"
echo "EFI: ${disk}1 (${efi_size}MiB)"
echo "Swap: ${disk}2 (${swap_size}MiB)" 
echo "Root: ${disk}3 (остальное)"