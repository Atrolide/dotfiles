#!/bin/bash

# Return if not running interactively
[[ $- != *i* ]] && return

# ===== Aliases =====
alias ls='lsd -l'
alias la='ls -A'
alias ll='lsd -l'
alias tree='lsd --tree -A --ignore-glob ".git"'
alias grep='grep --color=auto'
alias hx='helix'
alias ..='cd ..'
alias zathura='zathura --fork'
alias open='zathura --fork --config-dir=~/.config/zathura/catppuccin-mocha'

# ===== Prompt =====
PS1='╭─\[\e[1;38;5;213m\]   \[\e[0m\]\[\e[1;38;5;117m\]\u\[\e[0m\]\[\e[1;38;5;213m\]@\[\e[0m\]\[\e[1;38;5;117m\]\h \[\e[0m\]\[\e[1;38;5;228m\]in \W \[\e[0m\]\n╰─\[\e[1;38;5;204m\] 󰘧 \[\e[0m\] '

# ===== Environment Variables =====
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
    printf "\033[1;31m%s: command not found :c\033[0m\n" "$1" >&2
    return 127
}
