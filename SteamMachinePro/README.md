# Setup instructions for the BC-250



### ACPI Table/C-States Install:

##### Please run each line, 1 at a time in ther terminal

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
### Once the system has rebooted, your ready to to try some overclocking.

### For the Air Cooled Version (DIY Steam Machine) I recommedn the following: 

```console
bc250-detect --frequency 3850 --vid 1135 --temp 85 --keep
```

### To do a basic stability test, you can run the following

```console
stress-ng --matrix 0 -t 5m
```

### If that passes, then great leave it like this for now, and test some games and just use the system for a while before locking this in, if the mach crashes to a green screen, this will indicate you need to increase the voltage, so adjust the --vid 1135 up by 5 at a time, the default for the system is 1180, so anything under this is an undervolt and will result in a cooler running system.

### For the DIY Steam Machine Pro I recommend the following 2 profiles:

* Profile 1

```console
bc250-detect --frequency 4000 --vid 1275 --temp 75 --keep
```

* Profile 2

```console
bc250-detect --frequency 4100 --vid 1325 --temp 75 --keep
```

### To do a basic stability test, you can run the following

```console
stress-ng --matrix 0 -t 5m
```

### If that passes, then great leave it like this for now, and test some games and just use the system for a while before locking this in, if the mach crashes to a green screen, this will indicate you need to increase the voltage, so adjust the --vid up by 5 at a time
