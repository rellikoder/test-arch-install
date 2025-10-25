#!/bin/bash
# Переменные
disk="/dev/sda"
swap="16384"
filesystem=$((swap + 513))

# Диск
wipefs --all $disk

parted $disk mklabel gpt
parted $disk mkpart primary fat32 1MiB 513MiB
parted $disk set 1 esp on
parted $disk mkpart primary linux-swap 513Mib $((swap + 513)) 

mkfs.fat -F32 "${disk}1"
mkswap "${disk}2"
swapon "${disk}2"
#mkfs.ext4 "${disk}3"