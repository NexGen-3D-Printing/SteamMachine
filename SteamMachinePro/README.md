Setup instructions for the BC-250 running in the DIY Steam Machine Pro

Table of Contents

* Setup the Corsair COmmander Duo with OpenLinkHub
* Install the ACPI Tables (So the Powersave/Optimal/Permance power profiles all function correctly)
* Install the CPU Overclocking Software and Overclock the CPU (also added a section for undervolting the air colled DIY Steam Machine




Corsair Commander Duo Intallation:

The Controller requires software to be installed in order to use it, if you havea Windows machine, I highly recommend connecting it and updating the firmware on that machine first, as some have outdated firmware on them out of the box, and you will need to use the official Corsair software to update them.

* Official Corsair Software Link: https://www.corsair.com/ww/en/s/icue

* Recommended Firmware: https://www.corsair.com/ww/en/explorer/release-notes/controllers/commander-duo-09107-beta/

Once all that is done, you can connect it to you BC-250 and install the open source software to control it.

The software is called OpenLinkHub, feel free to go check it out, but the commands below will download and install it, https://github.com/jurkovic-nikola/OpenLinkHub please feel free to donate to his project if your able too.

Please run these commands, one line at a time to install OpenLinkHub:


```console
wget "https://github.com/jurkovic-nikola/OpenLinkHub/releases/latest/download/OpenLinkHub_$(curl -s https://api.github.com/repos/jurkovic-nikola/OpenLinkHub/releases/latest | jq -r '.tag_name')_amd64.tar.gz"
```
```console
tar xf OpenLinkHub_?.?.?_amd64.tar.gz -C /home/$USER/
```
```console
cd /home/$USER/OpenLinkHub
```
```console
chmod +x install-user-space.sh
```
```console
./install-user-space.sh
```
```console
systemctl reboot
```


Once the system has rebooted, then open the following folder in your Home directoy "OpenLinkHub" and open the onfig.json file, should just open in Kate, and go to line 4 and change:

```console
 "listenAddress": "127.0.0.1",
```
 To this:

```console
  "listenAddress": "0.0.0.0",
```


This will allow you to open the web GUI from your web browser on localhost:27003 on you local system, but also allow you to view and edit it on any other machine on your network, by simply entering the IP address of your BC-250 with the port number 27003, so example be 192.168.0.56:27003 then you can monitor and adjust things from a phne, tablet or another PC while your actually gaming on the BC-250 :) if you need to know what your ip address is, just open the terminal and type the following command:

```console
hostname -I
```





##### ACPI Table/C-States Install:

Please run each line, 1 at a time in ther terminal


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

Once completed, then restart the system using this command

```console
systemctl reboot
```




##### CPU Overclocking:

Enter one line at a time

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

Once completed, then restart the system using this command

```console
systemctl reboot
```

When the system has rebooted, you're now ready to try some overclocking.

For the Air Cooled Version (DIY Steam Machine) I recommedn the following: 


```console
bc250-detect --frequency 3850 --vid 1135 --temp 85 --keep
```

To do a basic stability test, you can run the following


```console
stress-ng --matrix 0 -t 5m
```


If that passes, then great leave it like this for now, and test some games and just use the system for a while before locking this in, if the machine crashes to a green screen, this will indicate you need to increase the voltage, so adjust the --vid up by 5 at a time, the default for the system is 1180, so anything under this is an undervolt and will result in a cooler running system.

For the DIY Steam Machine Pro I recommend the following 2 profiles:


* Profile 1

```console
bc250-detect --frequency 4000 --vid 1275 --temp 75 --keep
```


* Profile 2

```console
bc250-detect --frequency 4100 --vid 1325 --temp 75 --keep
```


To do a basic stability test, you can run the following

```console
stress-ng --matrix 0 -t 5m
```


If that passes, then great leave it like this for now, and test some games and just use the system for a while before locking this in, if the mach crashes to a green screen, this will indicate you need to increase the voltage, so adjust the --vid up by 5 at a time

Once you are 100% happy, and no crashing has happend, leave the system powered and idling in the Desktop environment for a few hours, as it some cases, it will crash at idle if things are not right, if this happens, then increase the --vid by another 5 and try again.

When you think the system is good, and you having no issues, you can now lock these settings in so they are applied at boot time, using the following:


```console
bc250-apply --install overclock.conf
```
```console
systemctl enable bc250-smu-oc
```

Job done and happy gaming :)
