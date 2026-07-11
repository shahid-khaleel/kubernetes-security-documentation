#!/usr/bin/env bash
# LUKS full-disk encryption of a data device (LAB: use a spare/loop device!).
set -euo pipefail
DEV="${1:?block device, e.g. /dev/sdb — DATA WILL BE ERASED}"
sudo cryptsetup luksFormat --type luks2 --cipher aes-xts-plain64 --key-size 512 "$DEV"
sudo cryptsetup open "$DEV" cryptdata
sudo mkfs.ext4 /dev/mapper/cryptdata
sudo cryptsetup luksHeaderBackup "$DEV" --header-backup-file luks-header.img   # BACK UP THE HEADER
echo "mapstatus:"; sudo cryptsetup status cryptdata
# Auto-mount: add to /etc/crypttab + /etc/fstab; TPM-bind with systemd-cryptenroll.
