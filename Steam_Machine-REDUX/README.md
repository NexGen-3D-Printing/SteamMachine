
# Specific setup commands for the Steam Machine REDUX


### Issue Fixes

USB to Sata Adaptors: This command will fix the slow performance and erratic behaviour of the Sabrent USB to Sata Adaptor, it may also fix other types, sysptems are slow, almost USB 2.0 speeds, drop outs, and slow detection, or failure to detect.

Copy and paste this into your terminal:
```console
rpm-ostree kargs --append-if-missing="usb-storage.quirks=2109:0715:u"
```
Once completed, then reboot using the following:
```console
systemctl reboot
```


### GPU Related Tweaks:

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
