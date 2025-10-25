#!/bin/bash
# Переменные
disk="/dev/sda"


# Диск
wipefs --all $disk

parted -s $disk mklabel gpt
parted -s $disk mkpart "EFI System" fat32 1MiB 513MiB
parted -s $disk set 1 esp on
parted -s $disk mkpart "Linux swap" linux-swap 513Mib 16897MiB 
parted -s $disk mkpart "Linux filesystem" ext4 16897Mib 100%

mkfs.fat -F32 "${disk}1"
mkswap "${disk}2"
swapon "${disk}2"
mkfs.ext4 "${disk}3"
