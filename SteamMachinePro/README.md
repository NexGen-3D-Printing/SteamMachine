# Setup instructions for the BC-250



## ACPI Table/C-States Install:

### Please run each line, 1 at a time in ther terminal

```console
git clone https://github.com/bc250-collective/bc250-acpi-fix.git
```
```console
cd bc250-acpi-fix
```
```console
mkdir -p /tmp/acpi_tables/kernel/firmware/acpi
```
```console
cp *.aml /tmp/acpi_tables/kernel/firmware/acpi/.
```
```console
cd /tmp/acpi_tables
```
```console
find kernel | cpio -H newc --create > SSDT_ACPI.cpio
```
```console
sudo cp SSDT_ACPI.cpio /boot/.
```
```console
echo 'GRUB_EARLY_INITRD_LINUX_CUSTOM="../../SSDT_ACPI.cpio"' | sudo tee -a /etc/default/grub
```
```console
ujust regenerate-grub
```

### once completed, then restart the system using this command

```console
systemctl reboot
```



## CPU Overclocking:

### Enter one line at a time

```console
rpm-ostree install stress
```
```console
git clone https://github.com/bc250-collective/bc250_smu_oc.git
```
```console
cd bc250_smu_oc
```
```console
pip install .
```

### once completed, then restart the system using this command

```console
systemctl reboot
```
