
Specific setup commands for the Steam Machine REDUX:

USB to Sata Adaptors: This command will fix the slow performance and erratic behaviour of the Sabrent USB to Sata Adaptor, it may also fix other types, sysptems are slow, almost USB 2.0 speeds, drop outs, and slow detection, or failure to detect.

Copy and paste this into your terminal:
```console
rpm-ostree kargs --append-if-missing="usb-storage.quirks=2109:0715:u"
```
Once completed, then reboot using the following:
```console
systemctl reboot
```

