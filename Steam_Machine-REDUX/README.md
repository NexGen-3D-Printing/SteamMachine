
# Specific setup commands for the Steam Machine REDUX

---------------------------------------------------------------------------------------------------------------------------------------------
### Issue Fixes
---------------------------------------------------------------------------------------------------------------------------------------------
USB to Sata Adaptors: This command will fix the slow performance and erratic behaviour of the Sabrent USB to Sata Adaptor, it may also fix other types, symptems are slow, almost USB 2.0 speeds, drop outs, and slow detection, or failure to detect.

Copy and paste this into your terminal:
```console
rpm-ostree kargs --append-if-missing="usb-storage.quirks=2109:0715:u"
```
Once completed, then reboot using the following:
```console
systemctl reboot
```

---------------------------------------------------------------------------------------------------------------------------------------------
### GPU Related Tweaks:
---------------------------------------------------------------------------------------------------------------------------------------------
#### Full Compute Unit Unlocking

Please do this before installing the govenor, just leave everything default and do the unlock first.

For unlocking the GPU to the full 40 Compute Unites, you can visit this repo and follow the directions https://github.com/WinnieLV/bc250-cu-live-manager or you can use the command below:

You will need to install the Universal Memory Mapper software before you can use the tool, so run the following command:
```console
rpm-ostree install umr
```
Then reboot using the following:
```console
systemctl reboot
```
After you have rebooted, then run the following, just copy paste all of this into the terminal:
```console
mkdir -p ~/NXG3D &&
cd ~/NXG3D &&
curl -L -o bc250-cu-live-manager.sh https://raw.githubusercontent.com/WinnieLV/bc250-cu-live-manager/refs/heads/main/bc250-cu-live-manager.sh &&
chmod +x bc250-cu-live-manager.sh &&
sudo ./bc250-cu-live-manager.sh
```
* First step is select "i" and install the service, just follow the prompts.
* Second step is "f" this will auto enable all compute cores, just follow the prompts.
* Third step, just minimise the Terminal, leave it open and running, open the Bazaar app store, install Furmark and Mission Center.
* Run Furmark and use Mission Center to monitor temps, and do some stability testing with Furmark
* If all is good, no artifacts or crashing, then go back to the Terminal running the unlocking tool, and select "w" and follow the prompts, this will enable the full unlock on bootup


---------------------------------------------------------------------------------------------------------------------------------------------
### CPU Related Tweaks:
---------------------------------------------------------------------------------------------------------------------------------------------
#### Install The CPU Overclocking Software

Disclaimer: All care is taken, no responsable accepted :) If you overclock, and it results in your car not starting, or microwave explodes, thats a you problem.

Now thats out of the way, onto the fun Hollywood style haxer stuff :)

First you will need to install the stress tool:
```console
rpm-ostree install stress
```
I like to keep all of these various tools in one folder, otherwise your home folder starts to get untidy, so creat the following folder.
```console
mkdir ~/NXG3D &&
cd ~/NXG3D
```
Clone the repo:
```console
git clone https://github.com/bc250-collective/bc250_smu_oc.git
```
Install the CPU Overclocking Tool
```console
cd ~/NXG3D/bc250_smu_oc
```
```console
pip install .
```
Once completed, then restart the system using this command
```console
systemctl reboot
```
Recommend jumping into the BIOS and setting up a custom fan profile: 

Profile 1: Use this with Overclock Profile 1
* Temperature 1 - 20C
* Speed for Temperature 1 - 5%
* Temperature 2 - 30C
* Speed for Temperature 2 - 10%
* Temperature 3 - 40C
* Speed for Temperature 3 - 15%
* Temperature 4 - 50C
* Speed for Temperature 1 - 20%
* Critical Temperature - 75C (Set to 85C If you want it even quieter, CPU and GPU with thermal throttle more)

Profile 2: Use this with Overclock Profile 2
* Temperature 1 - 20C
* Speed for Temperature 1 - 5%
* Temperature 2 - 30C
* Speed for Temperature 2 - 10%
* Temperature 3 - 40C
* Speed for Temperature 3 - 20%
* Temperature 4 - 50C
* Speed for Temperature 1 - 30%
* Critical Temperature - 85C (Set to 95C If you want it quieter, CPU and GPU with thermal throttle more)

When the system has rebooted, you're now ready to try some overclocking.

Generic Overclock Profiles for the REDUX Case using the P12 Pro CO fans

Profile 1: Cooler and Quieter (Recommend this with 2000mhz GPU and 40 CU Unlock, Roughly 14000 Points in Unigine Superpostion Medium)
```console
bc250-detect --frequency 3800 --vid 1125 --temp 80 --keep
```
Profile 2: Hotter and Louder (Recommend this with 2200mhz GPU and 40 CU Unlock, Roughly 14500 Points in Unigine Superpostion Medium)
```console
bc250-detect --frequency 3950 --vid 1200 --temp 90 --keep
```
If this is succesful, then run the following:
```console
stress-ng --matrix 0 -t 5m
```
If the system seems stable, I suggest using it for a little bit like this, a reboot will clear the overclock, so if you do have an issue, you can come back, run the overclock again but add 5 to the --vid or drop the clock a little, example -> bc250-detect --frequency 3850 --vid 1165 --temp 85 --keep

Once your happy with your OC, then run the following:

```console
bc250-apply --install overclock.conf
```
```console
systemctl enable bc250-smu-oc
```













