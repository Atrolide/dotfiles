# .config Directory

## Overview  
This directory contains user-specific configuration files for various applications including:  

- `alacritty`
- `fastfetch`
- `helix` 
- `hyprland`
- `swaylock`
- `wofi`  

## Symlinking

For the system to recognize these configurations, files must be properly linked to `~/.config/`:  

### (Optional but highly recommended) Backup existing configs:
```bash
mv ~/.config/<PACKAGE_NAME> ~/.config/<PACKAGE_NAME>.bak
```

### Create a symlink:  
```bash
ln -s /path/to/this/repo/<PACKAGE_NAME> ~/.config/<PACKAGE_NAME>
```

### (Optional) Check if the link was successfull:
```bash
ls -l ~/.config/<PACKAGE_NAME>
```

### Example:
```bash
mv ~/.config/alacritty ~/.config/alacritty.bak
ln -s ~/Repos/dotfiles/.config/alacritty ~/.config/alacritty
ls -l ~/.config/alacritty
```
