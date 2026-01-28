#!/usr/bin/env bash
# ────────────────────────────────────────────────────────────────
#  Setup-32GB (Bazzite) – NexGen3D v1.5
#
#  Created By:  NexGen3D for the BC‑250
#
#  What this script does:
#    1 Enable the filippor‑bazzite COPR repo
#    2 Install cyan-skillfish-governor-tt (Thermal Throttling)
#    3 Stop & disable oberon‑governor & cyan-skillfish-governor
#    4 Disable cpu mitigations and add zswap to GRUB
#    5 Create and enbable swapfile with lz4 compression
#    6 Enable rpm‑ostree initramfs features (lz4 + drivers)
#    7 Set vm.swappiness = 180
#    8 Diable zram
#
# ────────────────────────────────────────────────────────────────
systemctl disable --now cyan-skillfish-governor 2>/dev/null || true &&
systemctl disable --now cyan-skillfish-governor-tt 2>/dev/null || true &&
systemctl disable --now oberon‑governor 2>/dev/null || true &&
sudo copr enable filippor/bazzite <<< y 2>/dev/null || true &&
sudo rpm-ostree cleanup -m 2>/dev/null || true &&
sudo rpm-ostree refresh-md 2>/dev/null || true &&
rpm-ostree install cyan-skillfish-governor-smu 2>/dev/null || true &&
rpm-ostree kargs --append-if-missing=mitigations=off 2>/dev/null || true &&
rpm-ostree kargs --append-if-missing=zswap.enabled=1 2>/dev/null || true &&
rpm-ostree kargs --append-if-missing=zswap.max_pool_percent=25 2>/dev/null || true &&
rpm-ostree kargs --append-if-missing=zswap.compressor=lz4 2>/dev/null || true &&
sudo echo "" | sudo tee /etc/systemd/zram‑generator.conf 2>/dev/null || true &&
sudo swapoff /var/swap/swapfile 2>/dev/null || true &&
sudo rm -f /var/swap/swapfile 2>/dev/null || true &&
sudo btrfs subvolume delete /var/swap 2>/dev/null || true &&
sudo btrfs subvolume create /var/swap 2>/dev/null || true &&
sudo semanage fcontext -a -t var_t /var/swap 2>/dev/null || true &&
sudo restorecon /var/swap 2>/dev/null || true &&
sudo btrfs filesystem mkswapfile --size 32G /var/swap/swapfile 2>/dev/null || true &&
sudo semanage fcontext -a -t swapfile_t /var/swap/swapfile 2>/dev/null ||true &&
sudo restorecon /var/swap/swapfile 2>/dev/null ||true &&
sudo sed -i '/\/var\/swap\/swapfile/d' /etc/fstab
sudo bash -c 'echo /var/swap/swapfile none swap defaults,nofail 0 0 >> /etc/fstab'
sudo echo 'vm.swappiness = 180' | sudo tee /etc/sysctl.d/99-swappiness.conf || true &&
rpm-ostree initramfs --enable --arg=--add-drivers --arg=lz4 || true
echo "Setup Complete"
echo "Please reboot your system using the following command: systemctl reboot"
echo "After the system has rebooted, if you wish to test GPU overclocking, then run the following command in the terminal: systemctl start cyan-skillfish-governor-smu"
echo "CAUTION -> Overclocking the GPU can cause increased system heat and system instability"
