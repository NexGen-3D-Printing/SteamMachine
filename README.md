# NXG3D DIY SteamMachine

## Information and fixes for my DIY Steam Machine using the BC-250

## Link to my project on Printables: https://www.printables.com/model/1499974-nexgen3d-diy-steam-machine-powered-by-bazzite

### Bazzite optimisation scripts for the BC-250 SBC

### This script does the following:

### What this script does:

* Enable the filippor‑bazzite COPR repo

* Install cyan‑skillfish-governor-tt

* Stop & disable oberon‑governor and standard cyan-skillfish-governor

* Disable cpu mitigations and enable zswap

* Create a swapfile (16GB or 32GB Depending on script of choice)

* Enable lighter swap compression (lz4)

* Set vm.swappiness = 180

* Disable zram


### The only defference between these scripts is the swapfile size, if you have a large NVME storage solution then just go with 32GB, but if you only have a small drive, then wasting 32GB could be a tall order, so use the 16GB script, I haven't done enough testing to see if there is any impact, choose wisely :) do you take the Red Pill, or the Blue Pill.
 
 
## Script Installation 


### Blue Pill:

* To install the 16GB script, copy and paste all of these lines into your terminal altogether and hit enter:

```console
mkdir -p ~/NXG3D &&
cd ~/NXG3D &&
wget https://raw.githubusercontent.com/NexGen-3D-Printing/SteamMachine/main/Setup-16GB.sh &&
chmod +x ~/NXG3D/Setup-16GB.sh
```

* Then copy and paste this command into your terminal and hit enter:

```console
sudo su
```
* Then this one:

```console
./Setup-16GB.sh
```

### Red Pill:

* To install the 32GB script, copy and paste all of these lines into your terminal altogether and hit enter:

```console
mkdir -p ~/NXG3D &&
cd ~/NXG3D &&
wget https://raw.githubusercontent.com/NexGen-3D-Printing/SteamMachine/main/Setup-32GB.sh &&
chmod +x ~/NXG3D/Setup-32GB.sh
```

* Then copy and paste this command into your terminal and hit enter:

```console
sudo su
```
* Then this one:

```console
./Setup-32GB.sh
```
## Overclocking and Undervolting

* To edit the governor, you will find the configuration file here:

```console
/etc/cyan-skillfish-governor-tt/config.toml
```

* Just open and edit with Kate, or if inthe termminal, use Nano.

* You can add the following if you want to fully Overclock it:

```console
[[safe-points]]
frequency = 2230
voltage = 1055
```

* To under volt, I recommommend just drop 5mc from all safe points from 2050mhz and upwards, if you are having issues with it crashing, try increasing the 2000mhz safe point slowly up to 965mv as 950mv can be a little low for some boards.

* To apply ant changes to the config, run this:

```console
systemctl restart --now cyan-skillfish-governor-tt
```

* To check if the governor is running, run this:

```console
systemctl status --now cyan-skillfish-governor-tt
```

## Useful Links:

* Complete Guide for the BC-250: https://elektricm.github.io/amd-bc250-docs/

* FilippoR's Repo for the Governor used in my script: https://github.com/filippor/cyan-skillfish-governor/tree/tt

* Some excellent additinal information on the BC-250: https://github.com/mothenjoyer69/bc250-documentation

* A link to the community on Discord pushing the limits of this SBC: https://discord.gg/uDvkhNpxRQ

* Link to my YouTube Channel: https://www.youtube.com/@NexGen-3D

* Link to my Printables Profile: https://www.printables.com/@NexGen3D

(https://hits.dwyl.com/NexGen-3D-Printing/SteamMachine/tree/main.svg?style=flat-square)
