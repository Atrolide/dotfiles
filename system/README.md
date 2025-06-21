# `system` Directory

## Overview  
This directory contains system-wide configuration files for various applications including:  

- `sddm`

## Symlinking

For the system to recognize these configurations, files cannot be symlinked - they need to be copied into designated directories:  

```bash
cp /path/to/this/repo/system/etc/sddm.conf /etc/sddm.conf

cp -r /path/to/this/repo/system/usr/share/sddm/themes/catppuccin-mocha/ /usr/share/sddm/themes/catppuccin-mocha
````

## Enabling SDDM on startup
```bash
sudo systemctl enable sddm.service
```
