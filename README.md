
# <p align="center"> NexGen3D DIY Steam Machine - (BC-250) </p>



[![](https://github.com/NexGen-3D-Printing/SteamMachine/blob/main/Main_Image.jpg)]([https://github.com/NexGen-3D-Printing/SteamMachine/blob/main/Main_Image.jpg)

## <p align="center"> Information and fixes for my DIY Steam Machine using the BC-250 </p>


#### Links:

* My project on Printables: https://www.printables.com/model/1499974-nexgen3d-diy-steam-machine-powered-by-bazzite

* If you would like to donate or tip me for my work: https://ko-fi.com/nexgen3d

* If you're in Australia and would like to purchase one of my cases directly from me: https://www.ebay.com.au/str/nexgen3dprinting

* If you're in the US and you would like to purchase one of my Steam Machine cases professionally printed: https://www.etsy.com/listing/4433157329/bc-250-case-by-nexgen3d


#### This Bazzite optimisation script for the BC-250 SBC does the following:

* Enable the filippor‑bazzite COPR repo

* Install cyan‑skillfish-governor-smu (Enhanced Overclocking Version)

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
rm Setup-16GB.sh 2>/dev/null || true && 
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

* After the system has rebooted, if you wish to test GPU overclocking, then run the following command in the terminal:

```console
systemctl start cyan-skillfish-governor-smu
```

* CAUTION -> Overclocking the GPU can cause increased system heat and system instability

* Once you have tested overclocking using tools like Furmark and Unigine Superpostion, and are satisfied with system stability, then run the following to enable GPU overclocking permanently:

```console
systemctl enable --now cyan-skillfish-governor-smu
```

### Red Pill:

* To install the 32GB script, copy and paste all of these lines into your terminal altogether and hit enter:

```console
mkdir -p ~/NXG3D &&
cd ~/NXG3D &&
rm Setup-32GB.sh 2>/dev/null || true && 
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

* After the system has rebooted, if you wish to test GPU overclocking, then run the following command in the terminal:

```console
systemctl start cyan-skillfish-governor-smu
```

* CAUTION -> Overclocking the GPU can cause increased system heat and system instability

* Once you have tested overclocking using tools like Furmark and Unigine Superpostion, and are satisfied with system stability, then run the following to enable GPU overclocking permanently:

```console
systemctl enable --now cyan-skillfish-governor-smu
```


## Overclocking and Undervolting

* To edit the governor, you will find the configuration file here:

```console
/etc/cyan-skillfish-governor-smu/config.toml
```

* Just open and edit with Kate, or if in the termminal, use Nano.

* You can add the following if you want to Overclock it, after adding these, you are best to test out your thermals with Furmark:

```console
[[safe-points]]
frequency = 2250
voltage = 1050

[[safe-points]]
frequency = 2300
voltage = 1075

[[safe-points]]
frequency = 2350
voltage = 1100

[[safe-points]]
frequency = 2400
voltage = 1125
```

* To under volt, I recommommend just drop 5mc from all safe points from 2050mhz and upwards, if you are having issues with it crashing, try increasing the 2000mhz safe point slowly up to 965mv as 950mv can be a little low for some boards.

* To apply ant changes to the config, run this:

```console
systemctl restart cyan-skillfish-governor-smu
```

* To check if the governor is running, run this:

```console
systemctl status cyan-skillfish-governor-smu
```

## Useful Links:

* Complete Guide for the BC-250: https://elektricm.github.io/amd-bc250-docs/

* FilippoR's Repo for the Governor used in my script: https://github.com/filippor/cyan-skillfish-governor/tree/smu

* Some excellent additinal information on the BC-250: https://github.com/mothenjoyer69/bc250-documentation

* A link to the community on Discord pushing the limits of this SBC: https://discord.gg/uDvkhNpxRQ

* Link to my YouTube Channel: https://www.youtube.com/@NexGen-3D

* Link to my Printables Profile: https://www.printables.com/@NexGen3D

[![HitCount](https://hits.dwyl.com/NexGen-3D-Printing/SteamMachine.svg?style=flat-square)](http://hits.dwyl.com/NexGen-3D-Printing/SteamMachine)
