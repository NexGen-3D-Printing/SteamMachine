Instructions for Bazzite:

Install the TRCC Application:

```console
rpm-ostree install https://github.com/Lexonight1/thermalright-trcc-linux/releases/latest/download/trcc-linux-latest.noarch.rpm && systemctl reboot
```

Once that has completed, you will need to reboot

```console
systemctl reboot
```

Return to the desktop, and run the following

```console
usbreset 0416:5302 && trcc gui
```

Now configure the display how you want it to look using the software, make sure to save your theme, otherwise you will lose everything when you restart.

Also, make sure in the settings of that app, you uncheck the auto start feature, as we are going to make a service instead, this will ensure the display works in gamemode and desktop mode on boot up.

Now following the these instructions:

```console
sudo nano /etc/systemd/system/trcc-launcher.service
```

Then copy and paste all of this, just change the user to yours, its case sensative on Bazzite.


```console
[Unit]
Description=TRCC Launcher 
After=default.target network.target multi-user.target

[Service]
Type=simple
User=Change_To_Your_User
ExecStartPre=usbreset 0416:5302
ExecStart=trcc gui --resume
Restart=always
RestartSec=5
Environment=XDG_RUNTIME_DIR=/run/user/1000
Environment=WAYLAND_DISPLAY=wayland-0
Environment=DISPLAY=:0
Environment=QT_QPA_PLATFORM=wayland
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
```

Then reload the services:

```console
sudo systemctl daemon-reload
```

Then enable and start the service:

```console
sudo systemctl enable --now trcc-launcher.service
```
