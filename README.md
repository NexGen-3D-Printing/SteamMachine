# SteamMachine

 #################################################################
# Information and fixes for my DIY Steam Machine using the BC-250 #
 #################################################################

Link to my project on Printables: https://www.printables.com/model/1499974-nexgen3d-diy-steam-machine-powered-by-bazzite

Bazzite optimisation scripts for the BC-250 SBC.

This script does the following:

1 - Enable COPR repo filippor/bazzite (skip if already enabled)

2 - tall cyan‑skillfish‑governor‑tt (Thermal Throttling and Overclocking, will boost to 2230Mhz, and throttle if temps hit 85C automatically)

3 - Stop & disable oberon‑governor (If you have already installed this governor, it will disable it, not remove it, so you can re-enable if you want)

4 - Append mitigations=off to kernel args (This infers you are using this as a Steam Machine game console, if you are using this machine as your primary PC then I recommend not running this script)

5 - Create custom zRAM configuration and use compression with less CPU overhead (There is a few issues with ram and some games trying to use more that you actually have, this is to assist in reducing these issues)

6 - Reload systemd daemon

7 - Adjust vm.swappiness (This tells the OS to swap to more often to your NVME drive, this is to try and mitigate ram related issues with some titles)

 #####################
# Script Installation #
 #####################

To install the 4GB script, copy and paste all of these lines into your terminal altogether and hit enter:

mkdir -p ~/NXG3D && \
curl -L https://raw.githubusercontent.com/NexGen-3D-Printing/SteamMachine/main/BC-250-Setup-4G.sh \
     -o ~/NXG3D/BC-250-Setup-4G.sh && \
chmod +x ~/NXG3D/BC-250-Setup-4G.sh && \
cd ~/NXG3D

Then copy and paste this command into your terminal and hit enter:

./BC-Setup-4GB.sh

Now just follow the instruction posted at the end of the script.

################################################################

To install the 8GB script, copy and paste all of these lines into your terminal altogether and hit enter:

mkdir -p ~/NXG3D && \
curl -L https://raw.githubusercontent.com/NexGen-3D-Printing/SteamMachine/main/BC-250-Setup-8G.sh \
     -o ~/NXG3D/BC-250-Setup-8G.sh && \
chmod +x ~/NXG3D/BC-250-Setup-8G.sh && \
cd ~/NXG3D

Then copy and paste this command into your terminal and hit enter:

./BC-Setup-8GB.sh

Now just follow the instruction posted at the end of the script.

################################################################

You can swap between these 2 scripts without issues

################################################################

Useful Links:

Complete Guide for the BC-250: https://elektricm.github.io/amd-bc250-docs/

FilippoR's Repo for the Governor used in my script: https://github.com/filippor/cyan-skillfish-governor/tree/tt

Some excellent additinal information on the BC-250: https://github.com/mothenjoyer69/bc250-documentation

A link to the community on Discord pushing the limits of this SBC: https://discord.gg/uDvkhNpxRQ

Link to my YouTube Channel: https://www.youtube.com/@NexGen-3D

Link to my Printables Profile: https://www.printables.com/@NexGen3D

################################################################
