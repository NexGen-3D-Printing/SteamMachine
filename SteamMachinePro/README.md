# Setup instructions for the BC-250

#### Corsair Commander Duo Intallation:

##### The Controller requires software to be installed in order to use it, if you havea Windows machine, I highly recommend connecting it and updating the firmware on that machine first, as some have outdated firmware on them out of the box, and you will need to use the official Corsair software to update them.

* ##### Official Corsair Software Link: https://www.corsair.com/ww/en/s/icue

* ##### Recommended Firmware: https://www.corsair.com/ww/en/explorer/release-notes/controllers/commander-duo-09107-beta/

Once all that is done, you can connect it

#### ACPI Table/C-States Install:

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

##### Once completed, then restart the system using this command

```console
systemctl reboot
```



#### CPU Overclocking:

##### Enter one line at a time

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

##### Once completed, then restart the system using this command

```console
systemctl reboot
```
##### When the system has rebooted, you're now ready to try some overclocking.

##### For the Air Cooled Version (DIY Steam Machine) I recommedn the following: 

```console
bc250-detect --frequency 3850 --vid 1135 --temp 85 --keep
```

##### To do a basic stability test, you can run the following

```console
stress-ng --matrix 0 -t 5m
```

##### If that passes, then great leave it like this for now, and test some games and just use the system for a while before locking this in, if the machine crashes to a green screen, this will indicate you need to increase the voltage, so adjust the --vid up by 5 at a time, the default for the system is 1180, so anything under this is an undervolt and will result in a cooler running system.

##### For the DIY Steam Machine Pro I recommend the following 2 profiles:

* ##### Profile 1

```console
bc250-detect --frequency 4000 --vid 1275 --temp 75 --keep
```

* ##### Profile 2

```console
bc250-detect --frequency 4100 --vid 1325 --temp 75 --keep
```

##### To do a basic stability test, you can run the following

```console
stress-ng --matrix 0 -t 5m
```

##### If that passes, then great leave it like this for now, and test some games and just use the system for a while before locking this in, if the mach crashes to a green screen, this will indicate you need to increase the voltage, so adjust the --vid up by 5 at a time

##### Once you are 100% happy, and no crashing has happend, leave the system powered and idling in the Desktop environment for a few hours, as it some cases, it will crash at idle if things are not right, if this happens, then increase the --vid by another 5 and try again.

##### When you think the system is good, and you having no issues, you can now lock these settings in so they are applied at boot time, using the following:

```console
bc250-apply --install overclock.conf
```

```console
systemctl enable bc250-smu-oc
```

##### Job done
