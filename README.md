# SteamMachine

###############################################################

Information and fixes for my DIY Steam Machine using the BC-250

###############################################################

Link to my project on Printables: https://www.printables.com/model/1499974-nexgen3d-diy-steam-machine-powered-by-bazzite

Bazzite optimisation scripts for the BC-250 SBC.

This script does the following:

What this script does (in order):

1 - Enable the filippor‑bazzite COPR repo

2 - If cyan‑skillfish-governor is installed, uninstall it; then install cyan‑skillfish‑governor‑tt via rpm‑ostree

3 - Stop & disable oberon‑governor

4 - Add ‘mitigations=off’ to GRUB (performance‑only)

5 - Reload systemd daemon

6 - Create /var/swap sub‑volume (BTRFS)

7 - Make a 16 GiB swapfile inside that sub‑volume

8 - Add the swapfile to /etc/fstab for persistence

9 - Enable rpm‑ostree initramfs features (lz4 + drivers)

10 - Set vm.swappiness = 180

11 - Disable zram


The only defference between these scripts is the swapfile size, if you have a large NVME storage solution then just go with 32GB, but if you only have a small drive, then wasting 32GB could be a tall order, so use the 16GB script, I haven't done enough testing to see if there is any impact, choose wisely :) do you take the Red Pill, or the Blue Pill.
 
 
###################
 
Script Installation 
 
###################

Blue Pill

To install the 16GB script, copy and paste all of these lines into your terminal altogether and hit enter:


mkdir -p ~/NXG3D && \
curl -L https://raw.githubusercontent.com/NexGen-3D-Printing/SteamMachine/main/BC-250-Setup-16GB.sh \
     -o ~/NXG3D/BC-250-Setup-16GB.sh && \
chmod +x ~/NXG3D/BC-250-Setup-16GB.sh && \
cd ~/NXG3D


Then copy and paste this command into your terminal and hit enter:

./BC-250-Setup-16GB.sh

Now just follow the instruction posted at the end of the script.

################################################################

Red Pill

To install the 32GB script, copy and paste all of these lines into your terminal altogether and hit enter:


mkdir -p ~/NXG3D && \
curl -L https://raw.githubusercontent.com/NexGen-3D-Printing/SteamMachine/main/BC-250-Setup-32GB.sh \
     -o ~/NXG3D/BC-250-Setup-32GB.sh && \
chmod +x ~/NXG3D/BC-250-Setup-32GB.sh && \
cd ~/NXG3D


Then copy and paste this command into your terminal and hit enter:

./BC-250-Setup-32GB.sh

Now just follow the instruction posted at the end of the script.

################################################################

Useful Links:

Complete Guide for the BC-250: https://elektricm.github.io/amd-bc250-docs/

FilippoR's Repo for the Governor used in my script: https://github.com/filippor/cyan-skillfish-governor/tree/tt

Some excellent additinal information on the BC-250: https://github.com/mothenjoyer69/bc250-documentation

A link to the community on Discord pushing the limits of this SBC: https://discord.gg/uDvkhNpxRQ

Link to my YouTube Channel: https://www.youtube.com/@NexGen-3D

Link to my Printables Profile: https://www.printables.com/@NexGen3D

################################################################
