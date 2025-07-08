#!/bin/bash
LOGFILE="/home/atrolide/.dotfiles/packages/pacman.log"

tail -n 10 /var/log/pacman.log | grep -E 'installed|upgraded' | awk '{print $4}' | while read -r pkg; do
    grep -qxF "$pkg" "$LOGFILE" 2>/dev/null || echo "$pkg" >> "$LOGFILE"
done
