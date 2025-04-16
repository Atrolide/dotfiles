#!/bin/bash

# Return if not running interactively
[[ $- != *i* ]] && return

# ===== Color Definitions (Catppuccin Mocha) =====
export CP_BG="#1e1e2e"       # Background
export CP_TEXT="#cdd6f4"      # Foreground (text)
export CP_RED="#f38ba8"       # Errors/important
export CP_GREEN="#a6e3a1"     # Success/files
export CP_YELLOW="#f9e2af"    # Warnings
export CP_BLUE="#89b4fa"      # Info/links
export CP_PINK="#f5c2e7"      # Accent
export CP_TEAL="#94e2d5"      # Commands
export CP_ORANGE="#fab387"    # Highlights

# ===== Aliases =====
alias ls='lsd -1 --blocks name,permission,git,size --color=always'
alias la='ls -A'
alias ll='ls -l'
alias tree='lsd --tree -A --ignore-glob ".git"'
alias grep='grep --color=auto'
alias hx='helix'
alias ..='cd ..'

# ===== Prompt =====
PS1='╭─\[\e[1;38;5;213m\]   \[\e[0m\]\[\e[1;38;5;117m\]\u\[\e[0m\]\[\e[1;38;5;213m\]@\[\e[0m\]\[\e[1;38;5;117m\]\h \[\e[0m\]\[\e[1;38;5;228m\]in \W \[\e[0m\]\n╰─\[\e[1;38;5;204m\] 󰘧 \[\e[0m\] '

# ===== Environment Variables =====

# LSD Colors (Catppuccin Mocha theme)
export LSD_COLORS="di=34:ln=36:so=35:pi=33:ex=32:\
bd=34;46:cd=34;43:su=30;41:sg=30;46:\
tw=30;42:ow=30;43"

# Grep Colors
export GREP_COLORS="mt=01;31:sl=:cx=:fn=35:ln=32:bn=32:se=36"

# Man Page Colors
export LESS_TERMCAP_mb=$'\e[1;35m'     # Blinking (magenta)
export LESS_TERMCAP_md=$'\e[1;34m'     # Bold (blue)
export LESS_TERMCAP_me=$'\e[0m'        # End mode
export LESS_TERMCAP_so=$'\e[1;33m'     # Search highlight (yellow)
export LESS_TERMCAP_se=$'\e[0m'        # End search highlight
export LESS_TERMCAP_us=$'\e[1;32m'     # Underline (green)
export LESS_TERMCAP_ue=$'\e[0m'        # End underline

# ===== Functions =====
command_not_found_handle() {
    printf "\033[1;31m%s: command not found\033[0m\n" "$1" >&2
    return 127
}
