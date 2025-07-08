#!/bin/bash
LOGFILE="/home/atrolide/.dotfiles/packages/pacman.log"

# Get package names removed from last 10 lines of pacman.log
tail -n 10 /var/log/pacman.log | grep '\[ALPM\] removed ' | awk '{print $4}' | while read -r pkg; do
    # Remove package name line from LOGFILE (in-place)
    sed -i "/^${pkg}$/d" "$LOGFILE"
done
