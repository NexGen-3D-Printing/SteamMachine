#!/usr/bin/env bash
# ────────────────────────────────────────────────────────────────
#  Setup-AIO (Bazzite) – NexGen3D v1.5
#
#  Created By:  NexGen3D for the BC‑250
#
#  What this script does:
#    1 Install CPU Overclocking
#    9 Install C and P State ACPI Tables
#
# ────────────────────────────────────────────────────────────────
cd ~/ 2>/dev/null || true &&
git clone https://github.com/bc250-collective/bc250-acpi-fix.git 2>/dev/null || true &&
cd bc250-acpi-fix 2>/dev/null || true &&
mkdir -p /tmp/acpi_tables/kernel/firmware/acpi 2>/dev/null || true &&
cp *.aml /tmp/acpi_tables/kernel/firmware/acpi/. 2>/dev/null || true &&
cd /tmp/acpi_tables 2>/dev/null || true &&
find kernel | cpio -H newc --create > SSDT_ACPI.cpio 2>/dev/null || true &&
sudo cp SSDT_ACPI.cpio /boot/. 2>/dev/null || true &&
echo 'GRUB_EARLY_INITRD_LINUX_CUSTOM="../../SSDT_ACPI.cpio"' | sudo tee -a /etc/default/grub 2>/dev/null || true &&
ujust regenerate-grub 2>/dev/null || true &&
rpm-ostree install stress 2>/dev/null || true &&
cd ~/ 2>/dev/null || true &&
git clone https://github.com/bc250-collective/bc250_smu_oc.git 2>/dev/null || true &&
cd bc250_smu_oc 2>/dev/null || true &&
pip install . 2>/dev/null || true &&
echo "Setup Complete"
echo "Please reboot your system using the following command: systemctl reboot"
